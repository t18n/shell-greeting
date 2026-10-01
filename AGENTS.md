# Agent Instructions

`greeting` is the whole program: it prints a random quote from `quotes/` (one file per topic) with a random graphic in one of four flavors, each in its own folder: `graphics/art/` (ASCII), `graphics/pixel/` (pixel art), `graphics/braille/` (braille art) and `graphics/images/` (PNG/JPG). Settings are `GREETING_*` environment variables, documented in the README's Configuration section. Users can add content in folders listed in `GREETING_DIRS` (default `~/.config/shell-greeting`), with the same `quotes/` and `graphics/` layout.

## Adding content

Every addition to `quotes/` or `graphics/` goes through its skill, including one-off edits. Agents without slash-command skills read the skill file and follow its steps.

| Task | Skill | File |
| --- | --- | --- |
| Add quotes | `/generate-quotes <topic or instruction>` | `.claude/skills/generate-quotes/SKILL.md` |
| Add graphics | `/generate-graphics <topics or instructions>` | `.claude/skills/generate-graphics/SKILL.md` |

## Commands

```sh
# Run (random flavor), or force one
./greeting
./greeting --flavor pixel

# Preview one graphic; the flavor comes from its folder
./greeting graphics/pixel/cat.txt

# Output without colors or cursor codes
./greeting | awk '{ gsub(/\033\[[0-9;?]*[a-zA-Z]/, ""); print }'

# Convert a picture (needs ImageMagick)
tools/png-to-pixel picture.png > graphics/pixel/name.txt
tools/png-to-braille drawing.png > graphics/braille/name.txt

# Run every flavor in every installed shell
for s in sh bash dash ksh zsh; do for f in art pixel braille image; do command -v $s >/dev/null && $s -c "./greeting --flavor $f" >/dev/null && echo "$s $f ok"; done; done
```

## Key Conventions

- `greeting` uses only POSIX `sh` and POSIX `awk` features (no bash, zsh, or gawk extensions). Its only optional dependency is `chafa`, for real images; everything else falls back without it.
- Unicode output (box lines, half blocks) is written as octal byte escapes in the awk program, never as literal characters, and is only colored a whole line at a time, so no awk splits a multibyte character.
- `quotes/`, `graphics/art/` and `graphics/pixel/` are printable ASCII only: some awk versions count bytes, so a multibyte character shifts the bubble's right edge. `graphics/braille/` holds only braille characters and spaces.
- `README.md` states how many quotes and graphics each flavor has, in the Features table and the AI attribution line; keep the counts current.
- Personal facts come only from `date`, `uptime`, `df` and the counter file in `~/.local/state/shell-greeting/`; the script reads no shell history and sends nothing over the network.
- The awk program sits inside single quotes, so its messages are written without apostrophes ("It is Friday").
- `greeting` picks holiday graphics by file name in any flavor (ghost, skeleton, vampire, mummy, witch, zombie, werewolf, pumpkin, santa, snowman, elf); renaming one of those files means updating its holiday list too.
