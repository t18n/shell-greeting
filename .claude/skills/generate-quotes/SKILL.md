---
name: generate-quotes
description: Adds real, correctly attributed quotes to the topic files in quotes/ from a topic or instruction. Use when asked to add, find, generate, or replace quotes in shell-greeting.
argument-hint: <topic or instruction>
---

# Generate quotes

Request: $ARGUMENTS

If the line above shows a literal `$ARGUMENTS`, the request is the user's message. If there is no request, ask for a topic before starting.

## Steps

1. List `quotes/` and read every file in it. Each file is one topic (`programming.txt`, `startups.txt` and so on). Note the authors and quotes already there; each new quote is a new one.
2. Choose quotes that fit the request. Take the count from the request, or add 5. Every quote passes every rule in **Rules**.
3. Append each quote to the end of the topic file it fits best, in the **Format** below. A quote that fits no existing topic starts a new file, `quotes/<kebab-case-topic>.txt`; add the topic to the `GREETING_TOPICS` row in the README's Configuration table.
4. Run every command in **Checks** until all of them pass, then `sh tests/check-content.sh`, which must end with `content ok`.
5. In `README.md`, set the quote count in the Features list to the new total. The "AI attribution" line names the AI model that picked the quotes; if you are a different model, name both.
6. Report the added quotes, which ones use "attributed to", and any candidate you dropped with the reason.

## Format

```
%
The whole quote on one line; the script wraps it at 50 columns.
    -- Author
```

- A line containing only `%` separates entries. Start each new entry with a `%` line, unless the file's last line is already `%`.
- The author line is four spaces, `--`, one space, then the name.
- Printable ASCII only: straight quotes `'` and `"`, a plain hyphen `-` for any dash, and names without accents (`Antoine de Saint-Exupery`).

## Rules

- **Real words, real source.** Use quotes you can place in a book, talk, interview, letter, or a long-documented attribution, worded as the person said or wrote them.
- **Honest credit.** Write `-- attributed to Name` when the source is uncertain. For a known misattribution, credit the real source (`-- Will Durant, summarizing Aristotle`).
- **Short.** One or two sentences, under 200 characters. Short, credited quotes are what keeps this collection safe to publish; long passages from books, films, or speeches go beyond quotation rules.
- **Public figures and published works.** Song lyrics stay out because lyrics are licensed strictly even in fragments, and private individuals stay out.
- **Sayings.** A widely circulated saying with no author is credited as `-- Anonymous` or its origin (`-- Japanese proverb`).
- **Original lines** only when the request explicitly asks for them, credited as `-- Claude` (or your model's name), never to a real person.

## Checks

Run from the repository root. Each check passes when it prints nothing.

ASCII only:

```sh
LC_ALL=C grep -n '[^ -~]' quotes/*.txt
```

Every entry has an author line:

```sh
for f in quotes/*.txt; do awk '$0 == "%" { if (last !~ /^    -- ./) print FILENAME ":" NR - 1 ": entry has no author line"; next } { last = $0 } END { if (last !~ /^    -- ./) print FILENAME ":" NR ": entry has no author line" }' "$f"; done
```

No duplicate quotes:

```sh
cat quotes/*.txt | grep -v -e '^%$' -e '^    -- ' | sort | uniq -d
```

The new total for `README.md` counts every entry in every file:

```sh
awk 'FNR == 1 || $0 == "%" { n++ } END { print n }' quotes/*.txt
```
