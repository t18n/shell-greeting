# Records screenshots/demo.gif, which shows every flavor once.
# Install VHS (https://github.com/charmbracelet/vhs), then run from the repository root:
#   vhs demo.tape

Output screenshots/demo.gif

Set Shell "bash"
Set FontSize 15
Set Width 960
Set Height 700
Set Padding 20
Set Theme "Catppuccin Mocha"
Set TypingSpeed 40ms

Env COLORTERM "truecolor"
Env GREETING_SHINY "0"
Env GREETING_NAME "friend"

Type "./greeting --flavor art"
Enter
Sleep 3s
Hide
Type "clear"
Enter
Show

Type "./greeting --flavor pixel"
Enter
Sleep 3s
Hide
Type "clear"
Enter
Show

Type "./greeting --flavor braille"
Enter
Sleep 3s
Hide
Type "clear"
Enter
Show

Type "./greeting --flavor image"
Enter
Sleep 4s
