---
name: generate-graphics
description: Draws new original graphics for shell-greeting in any flavor (ASCII art, pixel art, braille art or illustrations) from topics or instructions. Use when asked to add, draw, generate, or redraw graphics, characters, sprites, images, animals, or cows in shell-greeting.
argument-hint: <topics or instructions>
---

# Generate graphics

Request: $ARGUMENTS

If the line above shows a literal `$ARGUMENTS`, the request is the user's message. If there is no request, ask for a topic before starting.

## Steps

1. Decide the flavor from the request: `art` (ASCII, the default when none is named), `pixel`, `braille` or `image`. List that flavor's folder and look at three existing files for size and style. Each new graphic gets a kebab-case name not already in that folder.
2. Make one graphic per topic in the request, following that flavor's section below and **Originality**.
3. Render each one and look at it as a picture:

   ```sh
   ./greeting --force graphics/<flavor-folder>/<name>.<ext> | awk '{ gsub(/\033\[[0-9;?]*[a-zA-Z]/, ""); print }'
   ```

   For `pixel` and `image`, also view a PNG preview with your image viewer (see the flavor sections), because stripped terminal output hides colors. The graphic is done when the subject is recognizable at a glance and symmetric parts line up. Redraw until it is.
4. Run that flavor's **Check** until it passes, then `sh tests/check-content.sh`, which must end with `content ok`.
5. In `README.md`, update that flavor's count in the Features table, and the per-flavor and total counts in the "AI attribution" line. That line names the AI model that drew the graphics; if you are a different model, name both.
6. Report the new files and show each rendered graphic.

## art: `graphics/art/<name>.txt`

- Plain text, printed exactly as written, directly under the speech bubble.
- Line 1 is two spaces and `\`. Line 2 starts with three spaces and `\`, and the drawing may continue on line 2 after it.
- At most 30 columns wide and 8 lines tall; printable ASCII only, spaces for indentation; faces use `oo` for eyes.
- Check (prints nothing when it passes):

  ```sh
  LC_ALL=C grep -n '[^ -~]' graphics/art/<name>.txt
  awk 'length > 30 { print FILENAME ":" FNR ": " length " columns" } FNR == 9 { print FILENAME ": more than 8 lines" }' graphics/art/<name>.txt
  ```

## pixel: `graphics/pixel/<name>.txt`

- Palette lines (`<symbol> #rrggbb`, and `. transparent`), a line `---`, then the pixel grid, one character per pixel, all rows the same length. At most 16 colors, 24 pixels wide and 16 tall; 16x16 is typical. ASCII only.
- Style: a dark outline, 2 or 3 shades per material, a transparent background, the subject filling most of the canvas.
- Draw the grid by hand, or draw a PNG and convert it: `tools/png-to-pixel picture.png > graphics/pixel/<name>.txt`.
- Preview: render the grid to a PNG scaled 16x on a dark background with Python and PIL in `$TMPDIR`, and view it.
- Check: write and run a short script confirming every grid character is in the palette, rows have equal length, the size and color limits hold, and `LC_ALL=C grep -n '[^ -~]'` finds nothing.

## braille: `graphics/braille/<name>.txt`

- Braille characters (U+2800 to U+28FF) and spaces, printed as is. At most 30 columns and 8 lines (60x32 dots), no trailing spaces.
- Draw bold black lines on white with Python and PIL in `$TMPDIR` (about 120x64 px), then convert: `tools/png-to-braille drawing.png > graphics/braille/<name>.txt`. Adjust the drawing until the braille is clean, with unbroken lines and no stray dots.
- Check: a short script confirming the line and column limits (count characters, not bytes), no trailing spaces, and only braille characters and spaces.

## image: `graphics/images/<name>.png`

- 512x512 RGBA PNG with a fully transparent background, drawn with Python and PIL (supersample, then downscale). It shows small, about 24x12 terminal cells, so use bold flat shapes, thick dark outlines and few details.
- Preview: view the PNG, and a 96x96 version on a dark background, closer to its size in the terminal.
- Check: a short script confirming 512x512, RGBA, transparent corners and some opaque pixels. Keep each file small (`optimize=True`, quantize if needed); the whole folder should stay under a few MB.

## Originality

- Draw every graphic from scratch as a generic subject: a cat, a penguin, a rocket.
- For a request that names a mascot, logo, brand, or franchise character, draw a generic version of the subject instead and say so in the report. Well-known artwork and branded characters belong to their creators and trademark owners, so this repository only publishes original drawings.
