#!/bin/sh
# Checks every quote and graphic against the content rules. Prints each problem and exits 1 if any.
# Usage: sh tests/check-content.sh   (from anywhere; POSIX sh, awk, grep and od only)

cd "$(dirname "$0")/.." || exit 1
export LC_ALL=C
problems=$(
  # Quotes: ASCII only, every entry ends with an author line, no duplicates
  grep -n '[^ -~]' quotes/*.txt | sed 's/^/non-ASCII: /'
  for f in quotes/*.txt; do
    awk '$0 == "%" { if (last !~ /^    -- ./) print FILENAME ":" NR - 1 ": entry has no author line"; next }
      { last = $0 } END { if (last !~ /^    -- ./) print FILENAME ":" NR ": entry has no author line" }' "$f"
  done
  cat quotes/*.txt | grep -v -e '^%$' -e '^    -- ' | sort | uniq -d | sed 's/^/duplicate quote: /'

  # ASCII art: ASCII only, at most 30 columns and 8 lines, starts with the two tail lines
  grep -n '[^ -~]' graphics/art/*.txt | sed 's/^/non-ASCII: /'
  awk 'length > 30 { print FILENAME ":" FNR ": " length " columns" }
    FNR == 9 { print FILENAME ": more than 8 lines" }' graphics/art/*.txt

  # Pixel art: valid palette, every pixel defined, equal rows, at most 24x16 and 16 colors
  grep -n '[^ -~]' graphics/pixel/*.txt | sed 's/^/non-ASCII: /'
  for f in graphics/pixel/*.txt; do
    awk '
      $0 == "---" { grid = 1; next }
      !grid {
        if ($0 !~ /^. (transparent|#[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f])$/) print FILENAME ":" FNR ": bad palette line"
        if (substr($0, 1, 1) in pal) print FILENAME ":" FNR ": symbol used twice"
        pal[substr($0, 1, 1)] = 1; colors++; next
      }
      {
        rows++
        if (width == "") width = length
        else if (length != width) print FILENAME ":" FNR ": row length differs"
        for (i = 1; i <= length; i++) if (!(substr($0, i, 1) in pal)) print FILENAME ":" FNR ": undefined pixel " substr($0, i, 1)
      }
      END {
        if (!grid) print FILENAME ": no --- line"
        if (width > 24 || rows > 16) print FILENAME ": larger than 24x16"
        if (colors > 17) print FILENAME ": more than 16 colors"
      }' "$f"
  done

  # Braille art: only braille characters and spaces, at most 30 columns and 8 lines, no trailing spaces
  awk '
    { line = $0; gsub(/\342\240[\200-\277]|\342\241[\200-\277]|\342\242[\200-\277]|\342\243[\200-\277]/, "x", line) }
    line ~ /[^x ]/ { print FILENAME ":" FNR ": character that is not braille" }
    length(line) > 30 { print FILENAME ":" FNR ": " length(line) " columns" }
    / $/ { print FILENAME ":" FNR ": trailing space" }
    FNR == 9 { print FILENAME ": more than 8 lines" }' graphics/braille/*.txt

  # Images: real PNG or JPEG files, each under 300 KB
  for f in graphics/images/*; do
    magic=$(od -An -tx1 -N4 "$f" | tr -d ' \n')
    case $f:$magic in
      (*.png:89504e47 | *.jpg:ffd8ff* | *.jpeg:ffd8ff*) ;;
      (*) echo "$f: not a PNG or JPEG file" ;;
    esac
    [ "$(wc -c < "$f")" -lt 307200 ] || echo "$f: larger than 300 KB"
  done
)

if [ -n "$problems" ]; then
  printf '%s\n' "$problems"
  exit 1
fi
echo "content ok: $(awk 'FNR == 1 || $0 == "%" { n++ } END { print n }' quotes/*.txt) quotes," \
  "$(ls graphics/art | wc -l | tr -d ' ') art, $(ls graphics/pixel | wc -l | tr -d ' ') pixel," \
  "$(ls graphics/braille | wc -l | tr -d ' ') braille, $(ls graphics/images | wc -l | tr -d ' ') images"
