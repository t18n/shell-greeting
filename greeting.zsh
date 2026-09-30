# Random quote from quotes.txt spoken by a random cow from cows/, in rainbow colors.
# quotes.txt uses the fortune format: entries separated by a line containing only "%".

zmodload zsh/mathfunc
typeset -g GREETING_DIR=${${(%):-%x}:A:h}

greeting() {
  local raw=$(<$GREETING_DIR/quotes.txt)
  local -a quotes=("${(@ps:\n%\n:)${raw%$'\n%'}}")
  local -a cows=($GREETING_DIR/cows/*.cow(N))

  local quote=${quotes[RANDOM % $#quotes + 1]}
  local cow=${cows[RANDOM % $#cows + 1]}

  { _greeting_bubble "$(print -r -- $quote | fold -s -w 50)"; _greeting_cow $cow } | _greeting_rainbow
}

_greeting_bubble() {
  setopt local_options extended_glob
  local -a lines=("${(@f)1}")
  lines=("${(@)lines%% #}")
  local w=0 line i left right
  for line in "${lines[@]}"; do (( ${#line} > w )) && w=${#line}; done

  print -r -- " ${(l:w+2::_:):-}"
  if (( $#lines == 1 )); then
    print -r -- "< ${lines[1]} >"
  else
    for (( i = 1; i <= $#lines; i++ )); do
      left='|' right='|'
      (( i == 1 )) && left='/' right='\'
      (( i == $#lines )) && left='\' right='/'
      print -r -- "$left ${(r:w:)lines[i]} $right"
    done
  fi
  print -r -- " ${(l:w+2::-:):-}"
}

# .cow files are Perl heredocs: take the body, undo the backslash escapes, then fill in the variables
_greeting_cow() {
  setopt local_options extended_glob
  local art=$(<$1)
  art=${art#*<<*$'\n'}
  art=${art%%$'\n'EOC*}
  art=${art//(#b)\\(?)/$match[1]}
  art=${art//\$thoughts/\\}
  art=${art//\$eyes/oo}
  art=${art//\$tongue/  }
  print -r -- $art
}

# Same sine-wave rainbow as lolcat (frequency 0.1, spread 3); 256-color fallback when truecolor isn't advertised
_greeting_rainbow() {
  local line out f r g b i row=0 offset=$(( RANDOM % 256 ))
  while IFS= read -r line; do
    out=
    for (( i = 1; i <= ${#line}; i++ )); do
      f=$(( 0.1 * (offset + row + i / 3.0) ))
      r=$(( int(sin(f) * 127 + 128) ))
      g=$(( int(sin(f + 2.094) * 127 + 128) ))
      b=$(( int(sin(f + 4.189) * 127 + 128) ))
      if [[ $COLORTERM == (truecolor|24bit) ]]; then
        out+=$'\e'"[38;2;$r;$g;${b}m${line[i]}"
      else
        out+=$'\e'"[38;5;$(( 16 + 36 * (r * 6 / 256) + 6 * (g * 6 / 256) + b * 6 / 256 ))m${line[i]}"
      fi
    done
    print -r -- "$out"$'\e[0m'
    (( row++ ))
  done
}
