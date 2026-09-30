---
name: generate-graphics
description: Draws new original ASCII graphics (cows) for the cows/ folder from topics or instructions. Use when asked to add, draw, generate, or redraw cows, animals, or graphics in shell-greeting.
argument-hint: <topics or instructions>
---

# Generate graphics

Request: $ARGUMENTS

If the line above shows a literal `$ARGUMENTS`, the request is the user's message. If there is no request, ask for a topic before starting.

## Steps

1. List `cows/` and read `cows/robot.txt`, `cows/owl.txt` and `cows/snail.txt` for size and style. Each new graphic gets a name not already in `cows/`.
2. Draw one graphic per topic in the request, following **Format** and **Originality**.
3. Save each as `cows/<kebab-case-name>.txt`.
4. Render each one and look at it as a picture:

   ```sh
   ./greeting cows/<name>.txt | awk '{ gsub(/\033\[[0-9;]*m/, ""); print }'
   ```

   The graphic is done when the subject is recognizable at a glance, symmetric parts line up column for column, and the two `\` lines lead from the bubble into the drawing. Redraw until all three hold.
5. Run every command in **Checks** until all of them pass.
6. In `README.md`, set the graphic count in the Features list and in the "AI attribution" line to the new total. That line names the AI model that drew the graphics; if you are a different model, name both.
7. Report the new files and paste each rendered graphic.

## Format

- Plain text, printed exactly as written, directly under the speech bubble.
- Line 1 is two spaces and `\`. Line 2 starts with three spaces and `\`, and the drawing may continue on line 2 after it.
- At most 30 columns wide and 8 lines tall, so the greeting fits a small terminal.
- Printable ASCII only, with spaces for indentation.
- Faces use `oo` for eyes, like the existing graphics.

## Originality

- Draw every graphic from scratch as a generic subject: a cat, a penguin, a rocket.
- For a request that names a mascot, logo, brand, or franchise character, draw a generic version of the subject instead and say so in the report. Well-known ASCII art pieces and branded characters belong to their creators and trademark owners, so this repository only publishes original drawings.

## Checks

Run from the repository root for each new file. Each check passes when it prints nothing.

ASCII only:

```sh
LC_ALL=C grep -n '[^ -~]' cows/<name>.txt
```

Size:

```sh
awk 'length > 30 { print FNR ": " length " columns" } END { if (NR > 8) print NR " lines" }' cows/<name>.txt
```

The new total for `README.md` is `ls cows/*.txt | wc -l`.
