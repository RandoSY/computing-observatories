#!/usr/bin/env bash
set -euo pipefail

commit=${1:?Supply the full GitHub commit SHA}
[[ $commit =~ ^[a-f0-9]{40}$ ]] || { printf 'Invalid commit SHA\n' >&2; exit 1; }
atlas=/var/www/html/atlas
target="$atlas/before-the-click"
source="https://raw.githubusercontent.com/RandoSY/computing-observatories/$commit/visible-state/before-the-click"
public=https://project-atlas-lab.duckdns.org/atlas/

for path in index.html before-the-click/index.html assets/calculus-theme.css assets/atlas.css assets/navigation.css assets/teatime.css; do
  [[ -s "$atlas/$path" ]] || { printf 'Required Atlas file missing: %s\n' "$path" >&2; exit 1; }
done

stage=$(mktemp -d "$atlas/.before-the-click-update.XXXXXX")
trap 'rm -r -- "$stage"' EXIT
curl -fsSL --retry 2 --connect-timeout 10 --max-time 60 "$source/index.html" -o "$stage/exhibit.html"
curl -fsSL --retry 2 --connect-timeout 10 --max-time 60 "$source/media/linc-lab.webp" -o "$stage/linc-lab.webp"
cp -- "$atlas/index.html" "$stage/home.original"

python3 - "$stage" <<'PY'
from pathlib import Path
import sys

stage = Path(sys.argv[1])
home = (stage / 'home.original').read_bytes()
newline = '\r\n' if b'\r\n' in home else '\n'
feature = '''<section class="atlas-feature" aria-labelledby="home-before-the-click">
<div>
<p class="atlas-kicker">Classroom exhibit · Experience before equation</p>
<h2 id="home-before-the-click"><a href="before-the-click/">Before the Click</a></h2>
<p>Sample a signal, test Apollo’s display, and draw with a light pen or a mouse. Five stations follow what early interactive machines receive, remember, and show.</p>
<p class="atlas-feature-links"><a href="before-the-click/Before_the_Click_Lab.html">Open the lab</a><a href="before-the-click/#classroom">Classroom materials</a></p>
</div>
<a href="before-the-click/"><img src="before-the-click/media/linc-lab.webp" width="1200" height="754" alt="Before the Click LINC station showing two sample runs against a moving signal" loading="lazy" decoding="async"></a>
</section>
'''.replace('\n', newline).encode('utf-8')
anchor = b'<div class="atlas-mini-grid" aria-label="More featured exhibits">'

if feature in home:
    updated = home
elif b'home-before-the-click' in home or b'before-the-click/' in home:
    raise SystemExit('An existing Before the Click entry needs to be reviewed before this update.')
elif home.count(anchor) != 1 or b'id="home-singing"' not in home:
    raise SystemExit('The Atlas homepage layout changed. Review the featured exhibit placement.')
else:
    updated = home.replace(anchor, feature + anchor, 1)

(stage / 'home.html').write_bytes(updated)
PY

grep -F 'class="tea-hero"' "$stage/exhibit.html" >/dev/null
grep -F 'media/linc-lab.webp' "$stage/exhibit.html" >/dev/null
chmod --reference="$atlas/index.html" "$stage/home.html"
chown --reference="$atlas/index.html" "$stage/home.html"
chmod --reference="$target/index.html" "$stage/exhibit.html"
chown --reference="$target/index.html" "$stage/exhibit.html"
chmod 644 "$stage/linc-lab.webp"
cmp -- "$stage/home.original" "$atlas/index.html"

mkdir -p -- "$target/media"
chmod 755 "$target/media"
mv -fT -- "$stage/linc-lab.webp" "$target/media/linc-lab.webp"
mv -fT -- "$stage/exhibit.html" "$target/index.html"
cmp -- "$stage/home.original" "$atlas/index.html"
if ! cmp -s -- "$stage/home.html" "$atlas/index.html"; then
  mv -fT -- "$stage/home.html" "$atlas/index.html"
fi

curl -fsS --connect-timeout 10 --max-time 30 "$public" | grep -F 'id="home-before-the-click"' >/dev/null
curl -fsS --connect-timeout 10 --max-time 30 "${public}before-the-click/" | grep -F 'id="linc-question"' >/dev/null
for path in '' media/linc-lab.webp Before_the_Click_Lab.html START_HERE.txt Student_Fieldbook.pdf Teacher_Guide.pdf 00/Before_the_Click_Classroom_Kit_v2.zip; do
  url="${public}before-the-click/$path"
  status=$(curl -fsS --connect-timeout 10 --max-time 30 -o /dev/null -w '%{http_code}' "$url")
  printf '%s %s\n' "$status" "$url"
  [[ $status == 200 ]]
done
printf 'Atlas homepage feature verified at %s\n' "$public"
