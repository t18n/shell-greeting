# shell-greeting

A random quote from `quotes.txt`, spoken by a random cow from `cows/`, in rainbow colors. It's plain zsh, so it doesn't need `fortune`, `cowsay` or `lolcat`.

It uses 24-bit color when `$COLORTERM` is `truecolor` or `24bit`, and 256 colors otherwise.

```zsh
source ~/Code/Workstation/shell-greeting/greeting.zsh
greeting
```

## Adding quotes

Put each entry on its own lines, then a line with only `%`. Don't end the file with `%`.

```
The quote text, as long as you like.
    -- Author
%
```

## Adding cows

A `.cow` file is a Perl heredoc:

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
- Check your cow with `_greeting_cow ./cows/name.cow`.

To also use the big collection, copy favorites from `../cowsay-files/cows/` into `cows/`. Only plain-ASCII cows work, which are the ones listed in `../cowsay-files/cowrc.sh`. Colored cows rely on Perl escape codes that this script doesn't understand.
