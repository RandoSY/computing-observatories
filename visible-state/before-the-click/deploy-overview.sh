#!/usr/bin/env bash
set -euo pipefail

commit=${1:?Supply the full GitHub commit SHA}
[[ $commit =~ ^[a-f0-9]{40}$ ]] || { printf 'Invalid commit SHA\n' >&2; exit 1; }

target='/var/www/html/atlas/before-the-click'
pdf='Before_the_Click_Activity_Overview.pdf'
src="https://raw.githubusercontent.com/RandoSY/computing-observatories/$commit/visible-state/before-the-click"
public='https://project-atlas-lab.duckdns.org/atlas/before-the-click/'

[[ -s "$target/index.html" ]] || { printf 'Required Atlas file missing: %s/index.html\n' "$target" >&2; exit 1; }

rm -rf -- "$target"/.overview-deploy.*
stage=$(mktemp -d "$target/.overview-deploy.XXXXXX")
trap 'rm -rf -- "$stage"' EXIT

curl -fsSL --retry 2 --connect-timeout 10 --max-time 60 "$src/$pdf" -o "$stage/$pdf"
curl -fsSL --retry 2 --connect-timeout 10 --max-time 60 "$src/index.html" -o "$stage/index.html"

[[ $(head -c 5 "$stage/$pdf") == '%PDF-' ]] || { printf 'Downloaded file is not a valid PDF\n' >&2; exit 1; }
size=$(wc -c < "$stage/$pdf")
[[ $size -eq 652563 ]] || { printf 'Unexpected PDF size: %s (expected 652563)\n' "$size" >&2; exit 1; }
grep -Fq "$pdf" "$stage/index.html" || { printf 'Updated index.html missing overview PDF link\n' >&2; exit 1; }
grep -Fq 'id="linc-question"' "$stage/index.html" || { printf 'Updated index.html missing expected exhibit marker\n' >&2; exit 1; }

chown --reference="$target/index.html" "$stage/$pdf" "$stage/index.html"
chmod 644 "$stage/$pdf" "$stage/index.html"
mv -fT -- "$stage/$pdf" "$target/$pdf"
mv -fT -- "$stage/index.html" "$target/index.html"

files=(
  ""
  "$pdf"
  "Before_the_Click_Lab.html"
  "START_HERE.txt"
  "Student_Fieldbook.pdf"
  "Teacher_Guide.pdf"
  "00/Before_the_Click_Classroom_Kit_v2.zip"
)
for file in "${files[@]}"; do
  status=$(curl -fsS --connect-timeout 10 --max-time 30 -o /dev/null -w '%{http_code}' "$public$file")
  printf '%s %s\n' "$status" "$public$file"
  [[ $status == 200 ]] || exit 1
done

curl -fsS --connect-timeout 10 --max-time 30 "${public}?v=$commit" | grep -Fq "$pdf"
printf 'Atlas overview deploy verified for commit %s\n' "$commit"
