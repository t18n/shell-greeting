# Agent Instructions

`greeting` is the whole program: it prints a random quote from `quotes.txt` in a speech bubble over a random graphic from `graphics/`, in rainbow colors.

## Adding content

Every addition to `quotes.txt` or `graphics/` goes through its skill, including one-off edits. Agents without slash-command skills read the skill file and follow its steps.

| Task | Skill | File |
| --- | --- | --- |
| Add quotes | `/generate-quotes <topic or instruction>` | `.claude/skills/generate-quotes/SKILL.md` |
| Add graphics | `/generate-graphics <topics or instructions>` | `.claude/skills/generate-graphics/SKILL.md` |

## Commands

```sh
# Run
./greeting

# Preview one graphic
./greeting graphics/owl.txt

# Output without colors
./greeting | awk '{ gsub(/\033\[[0-9;]*m/, ""); print }'

# Run in every installed shell
for s in sh bash dash ksh zsh fish; do command -v $s >/dev/null && $s -c ./greeting >/dev/null && echo "$s ok"; done
```

## Key Conventions

- `greeting` uses only POSIX `sh` and POSIX `awk` features (no bash, zsh, or gawk extensions) and no other dependencies, so it runs the same in any shell.
- `quotes.txt` and `graphics/*.txt` are printable ASCII only: some awk versions count bytes, so a multibyte character shifts the bubble's right edge.
- `README.md` states how many quotes and graphics there are; keep both counts current.
- `greeting` picks holiday graphics by file name (ghost, skeleton, vampire, mummy, witch, zombie, werewolf, santa, snowman, elf); renaming one of those files means updating its holiday list too.
