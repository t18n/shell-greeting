#!/bin/sh
# Runs the greeting the ways people use it and checks the output. Uses whatever awk is first on
# PATH, so CI can run it once per awk. Prints a line per check and exits 1 if any failed.
# Usage: sh tests/run.sh

cd "$(dirname "$0")/.." || exit 1
tmp=$(mktemp -d "${TMPDIR:-/tmp}/shell-greeting.XXXXXX") || exit 1
trap 'rm -rf "$tmp"' EXIT
export XDG_STATE_HOME="$tmp/state" XDG_CONFIG_HOME="$tmp/config"
unset GREETING_FLAVOR GREETING_WEIGHTS GREETING_TOPICS GREETING_DIRS GREETING_EVERY NO_COLOR
failed=0

ok() { echo "ok   $1"; }
fail() { echo "FAIL $1"; failed=1; }
check() { if eval "$2"; then ok "$1"; else fail "$1"; fi; }
plain() { awk '{ gsub(/\033\[[0-9;?]*[a-zA-Z]/, ""); print }'; }
style() {
  plain | awk '/^ *_+ *$/ { print "art"; exit } /\342\225\255/ { print "pixel"; exit }
    /\342\224\214/ { print "braille"; exit } /\342\226\214/ { print "image"; exit }'
}

# Every flavor in every installed shell, with nothing on stderr
for sh in sh bash dash ksh zsh fish "busybox sh"; do
  command -v ${sh%% *} >/dev/null 2>&1 || continue
  for flavor in art pixel braille image; do
    case $sh in zsh | fish) $sh -c "./greeting --force --flavor $flavor" > "$tmp/out" 2> "$tmp/err" ;;
      *) $sh ./greeting --force --flavor $flavor > "$tmp/out" 2> "$tmp/err" ;; esac
    check "$sh: $flavor runs cleanly" '[ -s "$tmp/out" ] && [ ! -s "$tmp/err" ]'
  done
done

# Each flavor draws its own style; images fall back to pixel art when nothing can show them
if command -v chafa >/dev/null 2>&1; then want_image=image; else want_image=pixel; fi
for flavor in art pixel braille image; do
  want=$flavor; [ $flavor = image ] && want=$want_image
  got=$(./greeting --force --flavor $flavor | style)
  check "--flavor $flavor draws $want" '[ "$got" = "$want" ]'
done

# Every graphic file renders
bad=''
for f in graphics/*/*; do
  ./greeting --force "$f" > "$tmp/out" 2> "$tmp/err" && [ -s "$tmp/out" ] && [ ! -s "$tmp/err" ] || bad="$bad $f"
done
check "every graphic renders" '[ -z "$bad" ]' ; [ -n "$bad" ] && echo "     failed:$bad"

# Options
check "--version" './greeting --version | grep -q "^shell-greeting [0-9]"'
check "--help" './greeting --help | grep -q "^Usage: greeting"'
files=$(awk 'FNR == 1 || $0 == "%" { n++ } END { print n }' quotes/*.txt)
check "--list counts every quote" './greeting --list | grep -q "total *$files$"'
check "unknown option exits 2" './greeting --nope 2>/dev/null; [ $? -eq 2 ]'
check "--flavor without a name exits 2" './greeting --flavor 2>/dev/null; [ $? -eq 2 ]'

# Behavior
check "quiet without a terminal" '[ -z "$(./greeting)" ]'
check "NO_COLOR prints no color codes" '! NO_COLOR=1 ./greeting --force | grep -q "$(printf "\033")"'
check "NO_COLOR keeps pixel art out" '[ "$(NO_COLOR=1 ./greeting --force --flavor pixel | style)" = art ]'
check "GREETING_SHINY=1 is always shiny" 'GREETING_SHINY=1 ./greeting --force | plain | grep -q "shiny!"'
check "GREETING_HELLO and GREETING_FACTS off" '[ "$(GREETING_HELLO=off GREETING_FACTS=off ./greeting --force --flavor art | plain | head -1 | tr -d " _")" = "" ]'
rm -rf "$XDG_STATE_HOME"
check "GREETING_FACTS=off writes nothing" 'GREETING_FACTS=off ./greeting --force >/dev/null; [ ! -e "$XDG_STATE_HOME/shell-greeting/count" ]'
check "the counter counts" 'rm -rf "$XDG_STATE_HOME"; ./greeting --force >/dev/null; ./greeting --force >/dev/null; [ "$(cut -d" " -f2 "$XDG_STATE_HOME/shell-greeting/count")" = 2 ]'

humor=$(grep '^    -- ' quotes/humor.txt | sed 's/^    -- //' | sort -u)
authors=$(for i in 1 2 3 4 5 6 7 8; do GREETING_TOPICS=humor ./greeting --force --flavor art | plain | sed -n 's/^[|\\] *-- \(.*[^ ]\) *[|/]$/\1/p'; done | sort -u)
check "GREETING_TOPICS keeps only that topic" '[ -n "$authors" ] && [ -z "$(printf "%s\n" "$authors" | grep -vxF "$humor")" ]'

mkdir -p "$XDG_CONFIG_HOME/shell-greeting/quotes" "$XDG_CONFIG_HOME/shell-greeting/graphics/art"
printf 'A quote from my own folder.\n    -- Me\n' > "$XDG_CONFIG_HOME/shell-greeting/quotes/mine.txt"
check "own folder quotes are used" 'GREETING_TOPICS=mine ./greeting --force | plain | grep -q "my own folder"'
check "GREETING_DIRS= turns own folders off" '! GREETING_DIRS= GREETING_TOPICS=mine ./greeting --force | plain | grep -q "my own folder"'

# GREETING_EVERY only applies without --force, which needs a terminal; a copy without the
# terminal check stands in for one.
mkdir -p "$tmp/app"
sed 's/^\[ -t 1 \] .* exit 0$/true/' greeting > "$tmp/app/greeting"
chmod +x "$tmp/app/greeting"; ln -s "$PWD/quotes" "$PWD/graphics" "$tmp/app/"
rm -rf "$XDG_STATE_HOME"
check "GREETING_EVERY shows the first greeting" '[ -n "$(GREETING_EVERY=1h "$tmp/app/greeting")" ]'
check "GREETING_EVERY skips the next one" '[ -z "$(GREETING_EVERY=1h "$tmp/app/greeting")" ]'
check "--force ignores GREETING_EVERY" '[ -n "$(GREETING_EVERY=1h "$tmp/app/greeting" --force)" ]'

echo
v=$(awk --version 2>/dev/null | head -1); [ -n "$v" ] || v=$(awk -W version 2>/dev/null | head -1); [ -n "$v" ] || v=awk
if [ $failed -eq 0 ]; then echo "all checks passed with $v"; else echo "some checks failed with $v"; fi
exit $failed
