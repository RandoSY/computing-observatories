# 65C02 Nugget validated-v6 simulator — exact recovery archive

This directory preserves the exact recovered byte stream of `65c02_nugget_simulator_validated_v6.html` from the Intellectual Estate Library.

The original HTML is **151,577 bytes**. To make the large single-file browser application reliable through the available GitHub archival connector, it was compressed with gzip, base64-encoded, and split into five deterministic text chunks:

- `65c02_nugget_simulator_validated_v6.html.gz.b64.part00`
- `65c02_nugget_simulator_validated_v6.html.gz.b64.part01`
- `65c02_nugget_simulator_validated_v6.html.gz.b64.part02`
- `65c02_nugget_simulator_validated_v6.html.gz.b64.part03`
- `65c02_nugget_simulator_validated_v6.html.gz.b64.part04`

This is an archival transport representation only. The recovered application itself was a normal standalone HTML file.

## Verification hashes

- Original HTML size: **151,577 bytes**
- Original HTML SHA-256: `a39e79a5b161fb4710cb3b8a3a8c98f5423099761445562122164fd358babca2`
- Gzip archive size: **42,374 bytes**
- Gzip archive SHA-256: `859415f596f10cf0378fb353681aed23447802095393f0b36ddf0de9bc9a96d6`

## Reassemble with Python

Run this from this directory:

```python
from pathlib import Path
import base64
import gzip
import hashlib

stem = "65c02_nugget_simulator_validated_v6.html"
parts = sorted(Path(".").glob(stem + ".gz.b64.part*"))
assert len(parts) == 5, f"expected 5 parts, found {len(parts)}"

b64_text = "".join(p.read_text(encoding="utf-8").strip() for p in parts)
gz_bytes = base64.b64decode(b64_text)
html_bytes = gzip.decompress(gz_bytes)

Path(stem + ".gz").write_bytes(gz_bytes)
Path(stem).write_bytes(html_bytes)

print("gzip bytes:", len(gz_bytes))
print("gzip sha256:", hashlib.sha256(gz_bytes).hexdigest())
print("html bytes:", len(html_bytes))
print("html sha256:", hashlib.sha256(html_bytes).hexdigest())
```

Expected output hashes:

```text
gzip sha256: 859415f596f10cf0378fb353681aed23447802095393f0b36ddf0de9bc9a96d6
html sha256: a39e79a5b161fb4710cb3b8a3a8c98f5423099761445562122164fd358babca2
```

After reconstruction, open `65c02_nugget_simulator_validated_v6.html` directly in a browser.

## Validation context

See the sibling files:

- `../EXTERNAL_VALIDATION_REPORT_v6.md`
- `../TEST_RESULTS.md`

The recovered evidence supports describing this as an extensively validated **instruction-level educational 65C02 simulator with corrected cycle metadata**. It is not claimed to be a transistor-level or pin-timing-certified W65C02 implementation.
