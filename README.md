# shell-greeting

Show a random quote, spoken by a random ASCII animal in rainbow colors, every time you open a terminal.

![screenshot](./screenshots/screenshot.jpeg)

It does the same job as `fortune | cowsay | lolcat` in one small script, without installing any of them. It only needs POSIX `sh` and `awk`, so it works the same in zsh, bash, fish, dash and ksh, on macOS, Linux, BSD and WSL.

## Installation

Clone the repository wherever you keep tools. This README uses `~/.local/share/shell-greeting`:

```sh
git clone https://github.com/t18n/shell-greeting.git ~/.local/share/shell-greeting
```

Try it:

```sh
~/.local/share/shell-greeting/greeting
```

Leave the folder together: the script looks for `quotes.txt` and `graphics/` next to itself. To run it from somewhere else, call it by its full path or make an alias (see below). A symlink won't work, because the script would look for `quotes.txt` and `graphics/` in the symlink's folder instead.

## Why I made this

I wanted every new terminal to greet me with a quote and a cow I picked, and I wanted it simple to install and easy to manage.

My first solution was `fortune | cowsay | lolcat` in my `.zshrc`, with a random cow from the [cowfiles](https://github.com/bkendzior/cowfiles) collection. It worked, but it meant installing three packages, and adding my own quote meant editing a fortune file and rebuilding its index with `strfile`.

I ended up with this repo. Installing it is one `git clone` and one line in your shell's startup file. The quotes are a plain text file and the graphics are a folder, so managing them is just editing files. It only needs `sh` and `awk`, so it runs in any shell.

## Features

- 186 curated quotes about programming, innovation, business, startups, science and philosophy.
- 113 characters, animals and objects, including a wizard, an astronaut, a pirate, a rubber duck and a coffee mug.
- A lolcat-style rainbow. It uses 24-bit color when your terminal supports it and 256 colors otherwise.
- About 1 greeting in 50 is a rare shiny one, painted in solid gold.
- Holiday characters: only spooky ones appear from October 25 to 31, and Santa, the snowman and the elf from December 20 to 26.
- Open a terminal between 1 and 5 a.m. and you get a nudge to go to bed instead of a quote.
- Graphics are plain text files, so you can draw your own in any editor.
- About 10 ms per run, so your shell doesn't start noticeably slower.

## Requirements

- A POSIX `sh`, `awk` and `od`. These are already on macOS, Linux, BSD and WSL.
- A terminal with 256-color or 24-bit color support.

## Show it when your shell starts

Add one line to your shell's startup file, then open a new terminal.

**zsh**, in `~/.zshrc`:

```zsh
~/.local/share/shell-greeting/greeting
```

If you use Powerlevel10k's instant prompt, put this line *above* the instant-prompt block, because instant prompt warns about output printed after it starts.

**bash**, in `~/.bashrc`:

```bash
~/.local/share/shell-greeting/greeting
```

On macOS, Terminal opens bash as a login shell, which reads `~/.bash_profile` instead. Make sure that file sources `~/.bashrc`, or put the line there.

**fish**, in `~/.config/fish/config.fish`:

```fish
if status is-interactive
    ~/.local/share/shell-greeting/greeting
end
```

**sh, dash or ksh**, in `~/.profile`, or in the file your `$ENV` points to:

```sh
case $- in *i*) ~/.local/share/shell-greeting/greeting ;; esac
```

The `case` check makes sure the greeting only prints in interactive shells, not when a script or `scp` starts a shell.

**Any shell, on demand:** add an alias so you can type `greeting` whenever you want another one:

```sh
alias greeting="$HOME/.local/share/shell-greeting/greeting"
```

In fish, use `alias greeting ~/.local/share/shell-greeting/greeting`.

## Customizing

### Quotes

Quotes live in `quotes.txt`, in the same format `fortune` uses: write each entry, then a line containing only `%`.

```
The quote text, as long as you like. Long lines are wrapped automatically.
    -- Author
%
```

Existing `fortune` files use this format, so you can paste their contents in. If their lines are already wrapped at about 72 characters, re-wrap them, or they'll break unevenly at the 50-character bubble width.

### Graphics

Each graphic is a plain `.txt` file in `graphics/`, printed exactly as you draw it, right under the bubble. Start with two `\` lines, so the bubble's tail leads into your drawing:

```
  \
   \   /\__/\
       ( oo )
```

To preview a graphic, pass it as an argument. With one or more graphic files as arguments, the script picks only from those:

```sh
~/.local/share/shell-greeting/greeting ~/.local/share/shell-greeting/graphics/owl.txt
```

If you have cowsay installed, you can convert a `.cow` file from another collection by rendering it once and dropping the three bubble lines:

```sh
cowsay -f some.cow x | tail -n +4 > ~/.local/share/shell-greeting/graphics/some.txt
```

### With an AI agent

Two skills add quotes and graphics following the rules above, check their work, and update the counts in this README. In Claude Code, run them from the repository folder:

```
/generate-quotes 5 quotes about debugging
/generate-graphics a rocket and a cactus
```

Other agents, such as Codex or Cursor, read `AGENTS.md`, which points them to the same skill files in `.claude/skills/`.

### Colors

The script uses 24-bit color when `$COLORTERM` is `truecolor` or `24bit`, and 256 colors otherwise. Most modern terminals set `COLORTERM` themselves. If yours supports 24-bit color but the rainbow looks banded, add `export COLORTERM=truecolor` to your shell's startup file.

## Uninstalling

Remove the line from your shell's startup file, then delete the folder:

```sh
rm -rf ~/.local/share/shell-greeting
```

## AI attribution

Built with Claude, Anthropic's AI model, which wrote the script and skills, drew the 113 graphics and picked the quotes; the words belong to the people credited, and "attributed to" marks an uncertain source.

## Acknowledgments

Inspired by the classic trio of [fortune](https://en.wikipedia.org/wiki/Fortune_(Unix)), [cowsay](https://en.wikipedia.org/wiki/Cowsay) by Tony Monroe, and [lolcat](https://github.com/busyloop/lolcat), whose rainbow formula this script reuses.

## License

MIT. See [`LICENSE`](LICENSE).
