#!/usr/bin/env bash
set -euo pipefail

commit=${1:?Supply the full GitHub commit SHA}
[[ $commit =~ ^[a-f0-9]{40}$ ]] || { printf 'Invalid commit SHA\n' >&2; exit 1; }
atlas=/var/www/html/atlas
target="$atlas/before-the-click"
public=https://project-atlas-lab.duckdns.org/atlas/

for path in index.html exhibits/index.html before-the-click/index.html before-the-click/media/linc-lab.webp; do
  [[ -s "$atlas/$path" ]] || { printf 'Required Atlas file missing: %s\n' "$path" >&2; exit 1; }
done
grep -F 'id="linc-question"' "$target/index.html" >/dev/null

stage=$(mktemp -d "$atlas/.before-the-click-listing.XXXXXX")
trap 'rm -r -- "$stage"' EXIT
cp -- "$atlas/index.html" "$stage/home.original"
cp -- "$atlas/exhibits/index.html" "$stage/exhibits.original"

python3 - "$stage" <<'PY'
from pathlib import Path
import sys

stage = Path(sys.argv[1])
home = (stage / 'home.original').read_bytes()
exhibits = (stage / 'exhibits.original').read_bytes()

def match_line_endings(text, page):
    return text.replace('\n', '\r\n' if b'\r\n' in page else '\n').encode('utf-8')

feature = match_line_endings('''<section class="atlas-feature" aria-labelledby="home-before-the-click">
<div>
<p class="atlas-kicker">Classroom exhibit · Experience before equation</p>
<h2 id="home-before-the-click"><a href="before-the-click/">Before the Click</a></h2>
<p>Sample a signal, test Apollo’s display, and draw with a light pen or a mouse. Five stations follow what early interactive machines receive, remember, and show.</p>
<p class="atlas-feature-links"><a href="before-the-click/Before_the_Click_Lab.html">Open the lab</a><a href="before-the-click/#classroom">Classroom materials</a></p>
</div>
<a href="before-the-click/"><img src="before-the-click/media/linc-lab.webp" width="1200" height="754" alt="Before the Click LINC station showing two sample runs against a moving signal" loading="lazy" decoding="async"></a>
</section>
''', home)
new_home = home.replace(feature, b'', 1)
if b'home-before-the-click' in new_home:
    raise SystemExit('The homepage feature differs from the published version. Review it before removing it.')

card = match_line_endings('''<article class="atlas-exhibit" id="exhibit-before-the-click">
<a class="atlas-exhibit-visual" href="../before-the-click/" aria-label="Open Before the Click">
<img src="../before-the-click/media/linc-lab.webp" width="1200" height="754" alt="" decoding="async"></a>
<div class="atlas-exhibit-body">
<p class="atlas-kicker">Classroom exhibit · Interactive computing</p>
<h2><a href="../before-the-click/">Before the Click</a></h2>
<p class="atlas-exhibit-summary">Sample a signal, test Apollo’s display, and draw with a light pen or a mouse. Five stations trace what early interactive systems receive, remember, and show.</p>
</div></article>''', exhibits)
anchor = match_line_endings('''<article class="atlas-exhibit atlas-premier">
<a class="atlas-exhibit-visual" href="../pop-can-calorimeter/"''', exhibits)

if card in exhibits and exhibits.count(b'id="exhibit-before-the-click"') == 1:
    new_exhibits = exhibits
elif b'exhibit-before-the-click' in exhibits or b'../before-the-click/' in exhibits:
    raise SystemExit('An existing Before the Click gallery entry needs review.')
elif exhibits.count(anchor) != 1 or b'<div class="atlas-exhibits">' not in exhibits:
    raise SystemExit('The Atlas Exhibits layout changed. Review the card placement.')
else:
    new_exhibits = exhibits.replace(anchor, card + anchor, 1)

(stage / 'home.html').write_bytes(new_home)
(stage / 'exhibits.html').write_bytes(new_exhibits)
PY

cmp -- "$stage/home.original" "$atlas/index.html"
cmp -- "$stage/exhibits.original" "$atlas/exhibits/index.html"

if ! cmp -s -- "$stage/exhibits.html" "$atlas/exhibits/index.html"; then
  chown --reference="$atlas/exhibits/index.html" "$stage/exhibits.html"
  chmod --reference="$atlas/exhibits/index.html" "$stage/exhibits.html"
  mv -fT -- "$stage/exhibits.html" "$atlas/exhibits/index.html"
fi
cmp -- "$stage/home.original" "$atlas/index.html"
if ! cmp -s -- "$stage/home.html" "$atlas/index.html"; then
  chown --reference="$atlas/index.html" "$stage/home.html"
  chmod --reference="$atlas/index.html" "$stage/home.html"
  mv -fT -- "$stage/home.html" "$atlas/index.html"
fi

curl -fsS --connect-timeout 10 --max-time 30 "${public}exhibits/?v=$commit" -o "$stage/exhibits.public"
grep -F 'id="exhibit-before-the-click"' "$stage/exhibits.public" >/dev/null
grep -F 'href="../before-the-click/">Before the Click</a>' "$stage/exhibits.public" >/dev/null
curl -fsS --connect-timeout 10 --max-time 30 "${public}?v=$commit" -o "$stage/home.public"
if grep -F 'home-before-the-click' "$stage/home.public" >/dev/null; then
  printf 'Atlas is still serving the former homepage feature.\n' >&2
  exit 1
fi
curl -fsS --connect-timeout 10 --max-time 30 "${public}before-the-click/" -o "$stage/exhibit.public"
grep -F 'id="linc-question"' "$stage/exhibit.public" >/dev/null
printf 'Atlas Exhibits listing verified at %sexhibits/#exhibit-before-the-click\n' "$public"
printf 'Homepage feature removed. The exhibit page is accessible.\n'
