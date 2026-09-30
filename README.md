# shell-greeting

Show a random quote, spoken by a random ASCII animal in rainbow colors, every time you open a terminal.

```
 __________________________________
/ Talk is cheap. Show me the code. \
\     -- Linus Torvalds            /
 ----------------------------------
  \
   \     __
       <(oo)___
        (  ._> /
         `----'
```

It does the same job as `fortune | cowsay | lolcat` in one small script, without installing any of them. It only needs POSIX `sh` and `awk`, so it works the same in zsh, bash, fish, dash and ksh, on macOS, Linux, BSD and WSL.

## Why I made this

I wanted every new terminal to greet me with a quote and a cow I picked, and I wanted it simple to install and easy to manage.

My first solution was `fortune | cowsay | lolcat` in my `.zshrc`, with a random cow from the [cowfiles](https://github.com/bkendzior/cowfiles) collection. It worked, but it meant installing three packages, and adding my own quote meant editing a fortune file and rebuilding its index with `strfile`.

I ended up with this repo. Installing it is one `git clone` and one line in your shell's startup file. The quotes are a plain text file and the cows are a folder, so managing them is just editing files. It only needs `sh` and `awk`, so it runs in any shell.

## Features

- 86 curated quotes about programming, science and philosophy.
- 13 animals and objects, including a rubber duck, an owl, a robot and a coffee mug.
- A lolcat-style rainbow. It uses 24-bit color when your terminal supports it and 256 colors otherwise.
- Works with standard `.cow` files, so you can bring your own animals.
- About 10 ms per run, so your shell doesn't start noticeably slower.

## Requirements

- A POSIX `sh`, `awk` and `od`. These are already on macOS, Linux, BSD and WSL.
- A terminal with 256-color or 24-bit color support.

## Installation

Clone the repository wherever you keep tools. This README uses `~/.local/share/shell-greeting`:

```sh
git clone https://github.com/t18n/shell-greeting.git ~/.local/share/shell-greeting
```

Try it:

```sh
~/.local/share/shell-greeting/greeting
```

Leave the folder together: the script looks for `quotes.txt` and `cows/` next to itself. To run it from somewhere else, call it by its full path or make an alias (see below). A symlink won't work, because the script would look for `quotes.txt` and `cows/` in the symlink's folder instead.

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

### Animals

Each file in `cows/` is a standard cowsay `.cow` file, which is a Perl heredoc:

```perl
$the_cow = <<EOC;
  $thoughts
   $thoughts   /\\__/\\
       ( $eyes )
EOC
```

- `$thoughts` draws the bubble's tail line, and `$eyes` is 2 characters wide.
- Escape every literal `\` as `\\`, and every literal `$` or `@` as `\$` or `\@`.
- The heredoc must end with a line containing only `EOC`.

To preview a cow, pass it as an argument. With one or more cow files as arguments, the script picks only from those:

```sh
~/.local/share/shell-greeting/greeting ~/.local/share/shell-greeting/cows/owl.cow
```

Plain-ASCII `.cow` files from cowsay or other collections work too: drop them into `cows/`. Colored cows don't work, because they rely on Perl escape codes this script doesn't understand.

### Colors

The script uses 24-bit color when `$COLORTERM` is `truecolor` or `24bit`, and 256 colors otherwise. Most modern terminals set `COLORTERM` themselves. If yours supports 24-bit color but the rainbow looks banded, add `export COLORTERM=truecolor` to your shell's startup file.

## Uninstalling

Remove the line from your shell's startup file, then delete the folder:

```sh
rm -rf ~/.local/share/shell-greeting
```

## Acknowledgments

Inspired by the classic trio of [fortune](https://en.wikipedia.org/wiki/Fortune_(Unix)), [cowsay](https://en.wikipedia.org/wiki/Cowsay) by Tony Monroe, and [lolcat](https://github.com/busyloop/lolcat), whose rainbow formula this script reuses.
