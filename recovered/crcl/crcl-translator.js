/*
 * CRCL -> MicroBlocks Translator v0.1
 *
 * A deliberately small compiler for the Common Robot Control Language (CRCL),
 * a Forth-like robot dialect. It translates a portable subset of Forth into
 * MicroBlocks textual UBL/UBP source.
 *
 * Design principle:
 *   - CRCL application words stay hardware-neutral.
 *   - Robot primitives compile to calls into a target adapter library.
 *   - Stack effects on colon definitions provide function signatures.
 *
 * Supported in v0.1:
 *   literals, constants, variables, @ ! +!,
 *   DUP DROP SWAP OVER,
 *   + - * / MOD ABS MIN MAX NEGATE,
 *   = <> < > <= >= 0= 0< 0>,
 *   AND OR XOR NOT,
 *   IF ELSE THEN,
 *   colon definitions with stack comments, e.g. : FOO ( a b -- c ) ... ;
 *   calls to previously defined CRCL words,
 *   calls to a standard robot primitive adapter.
 *
 * Not yet translated: BEGIN/UNTIL/AGAIN/WHILE/REPEAT, DO/LOOP, CREATE/DOES>.
 * The robot architecture intentionally prefers a finite ROBOT-STEP word.
 *
 * MIT-style project code; see README for provenance of generated MicroBlocks
 * syntax examples and current limitations.
 */

(function (root, factory) {
  if (typeof module === 'object' && module.exports) module.exports = factory();
  else root.CRCLTranslator = factory();
})(typeof globalThis !== 'undefined' ? globalThis : this, function () {
  'use strict';

  class CRCLCompileError extends Error {
    constructor(message, token = null) {
      super(token && token.line ? `Line ${token.line}: ${message}` : message);
      this.name = 'CRCLCompileError';
      this.token = token;
    }
  }

  const DEFAULT_ROBOT_WORDS = {
    'LEFT-MOTOR!':    { in: ['power'], out: [], mb: 'crcl_leftMotor', kind: 'command', description: 'set left motor power _' },
    'RIGHT-MOTOR!':   { in: ['power'], out: [], mb: 'crcl_rightMotor', kind: 'command', description: 'set right motor power _' },
    'MOTORS!':        { in: ['left', 'right'], out: [], mb: 'crcl_motors', kind: 'command', description: 'set left motor _ right motor _' },
    'STOP':           { in: [], out: [], mb: 'crcl_stop', kind: 'command', description: 'stop both motors' },
    'LEFT-ENCODER@':  { in: [], out: ['ticks'], mb: 'crcl_leftEncoder', kind: 'reporter', description: 'left encoder ticks' },
    'RIGHT-ENCODER@': { in: [], out: ['ticks'], mb: 'crcl_rightEncoder', kind: 'reporter', description: 'right encoder ticks' },
    'FRONT-RANGE@':   { in: [], out: ['mm'], mb: 'crcl_frontRange', kind: 'reporter', description: 'front range mm' },
    'GYRO-Z@':        { in: [], out: ['mdeg_s'], mb: 'crcl_gyroZ', kind: 'reporter', description: 'gyro Z millidegrees per second' },
    'SCAN-ANGLE!':    { in: ['deg'], out: [], mb: 'crcl_scanAngle', kind: 'command', description: 'set scan angle _ degrees' },
    'SCAN-RANGE@':    { in: [], out: ['mm'], mb: 'crcl_scanRange', kind: 'reporter', description: 'scan range mm' },
    'MILLIS':         { in: [], out: ['ms'], mb: 'millisOp', kind: 'reporter', builtin: true, description: 'milliseconds' },
    'BATTERY-MV@':    { in: [], out: ['mv'], mb: 'crcl_batteryMv', kind: 'reporter', description: 'battery millivolts' }
  };

  function quoteMB(s) {
    return `'${String(s).replace(/'/g, "''")}'`;
  }

  function sanitizeName(name) {
    return name.replace(/[^A-Za-z0-9_]/g, '_');
  }

  function tokenize(source) {
    const tokens = [];
    let i = 0, line = 1;
    const push = (type, value, startLine = line) => tokens.push({ type, value, line: startLine });

    while (i < source.length) {
      const c = source[i];
      if (c === '\n') { line++; i++; continue; }
      if (/\s/.test(c)) { i++; continue; }

      // Forth backslash comment.
      if (c === '\\') {
        while (i < source.length && source[i] !== '\n') i++;
        continue;
      }

      // Parenthesized comment; stack-effect comments are retained.
      if (c === '(') {
        const startLine = line;
        let j = i + 1;
        let text = '';
        while (j < source.length && source[j] !== ')') {
          if (source[j] === '\n') line++;
          text += source[j++];
        }
        if (j >= source.length) throw new CRCLCompileError('unterminated parenthesized comment', { line: startLine });
        push('comment', text.trim(), startLine);
        i = j + 1;
        continue;
      }

      // Dot-quote string. Keep as one token for future expansion; v0.1 accepts it only as statement output.
      if (source.startsWith('."', i)) {
        const startLine = line;
        i += 2;
        let text = '';
        while (i < source.length && source[i] !== '"') {
          if (source[i] === '\n') line++;
          text += source[i++];
        }
        if (source[i] !== '"') throw new CRCLCompileError('unterminated ." string', { line: startLine });
        i++;
        push('dotstring', text, startLine);
        continue;
      }

      const startLine = line;
      let j = i;
      while (j < source.length && !/\s/.test(source[j]) && source[j] !== '(' && source[j] !== '\\') j++;
      push('word', source.slice(i, j), startLine);
      i = j;
    }
    return tokens;
  }

  function parseStackEffect(text) {
    if (!text || !text.includes('--')) return null;
    const [lhs, rhs] = text.split('--', 2);
    const clean = s => s.trim().split(/\s+/).filter(Boolean).filter(x => x !== '--');
    const normalize = arr => arr.map((x, idx) => {
      let v = x.replace(/[^A-Za-z0-9_]/g, '_');
      if (!v || /^_+$/.test(v)) v = `arg${idx + 1}`;
      if (/^\d/.test(v)) v = `arg_${v}`;
      return v;
    });
    return { in: normalize(clean(lhs)), out: normalize(clean(rhs)) };
  }

  function parse(source) {
    const toks = tokenize(source);
    const program = { constants: new Map(), variables: new Set(), words: [], startup: [] };
    let i = 0;

    function needWord(msg) {
      const t = toks[i++];
      if (!t || t.type !== 'word') throw new CRCLCompileError(msg, t || toks[i - 1]);
      return t;
    }

    while (i < toks.length) {
      const t = toks[i++];
      if (t.type !== 'word') continue;
      const upper = t.value.toUpperCase();

      if (upper === ':') {
        const nameTok = needWord('expected word name after :');
        let sig = { in: [], out: [] };
        if (toks[i] && tokks[i].type === 'comment') {
          const parsed = parseStackEffect(toks[i].value);
          if (parsed) { sig = parsed; i++; }
        }
        const body = [];
        let depth = 0;
        while (i < toks.length) {
          const b = toks[i++];
          if (b.type === 'word') {
            const u = b.value.toUpperCase();
            if (u === 'IF') depth++;
            else if (u === 'THEN') depth--;
            if (u === ';' && depth === 0) break;
          }
          body.push(b);
        }
        if (!body.length && (!toks[i - 1] || toks[i - 1].value !== ';')) {
          throw new CRCLCompileError(`unterminated definition ${nameTok.value}`, nameTok);
        }
        program.words.push({ name: nameTok.value, sig, body, line: nameTok.line });
        continue;
      }

      if (upper === 'VARIABLE') {
        const n = needWord('expected variable name');
        program.variables.add(n.value);
        continue;
      }

      // Forth constant form: <literal> CONSTANT NAME
      if (/^\/=?(?:\d+(?:\.\d*)?|\.\d+)$/.test(t.value) && toks[i] && toks[i].type === 'word' && toks[i].value.toUpperCase() === 'CONSTANT') {
        i++;
        const n = needWord('expected constant name');
        program.constants.set(n.value, Number(t.value));
        continue;
      }

      if (upper === 'CONSTANT') {
        throw new CRCLCompileError(`use Forth form <literal> CONSTANT <name>`, t);
      }

      program.startup.push(t);
    }
    return program;
  }

  // ... [full source continues in the preserved blob] ...

  return {
    version: '0.1.0',
    CRCLCompileError,
    DEFAULT_ROBOT_WORDS,
    tokenize,
    parse,
    compile,
    toUBL,
    toUBP,
    adapterStubUBL,
    diagnostics
  };
});
