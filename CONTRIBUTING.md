# Contributing

Thanks for helping. New quotes and graphics are the most welcome contributions; changes to the script are welcome too, as long as it keeps running in any shell.

## Adding quotes or graphics

- The formats are in the README's [Customizing](README.md#customizing) section.
- Quotes must be real, short and correctly credited; graphics must be your own original work, with no logos, mascots or franchise characters. The full rules are in the two skills, `.claude/skills/generate-quotes/SKILL.md` and `.claude/skills/generate-graphics/SKILL.md`, which also work as a checklist when you add content by hand.
- With an AI coding agent, run `/generate-quotes <topic>` or `/generate-graphics <topic>`; other agents follow `AGENTS.md`.
- Update the counts in the README's Features table and AI attribution line.
- Run the content check before opening a pull request:

  ```sh
  sh tests/check-content.sh
  ```

## Changing the script

- `greeting` must stay POSIX `sh` and POSIX `awk`. The other conventions, like how Unicode is written in the awk program, are in the Key Conventions section of `AGENTS.md`.
- Run the tests. They use whatever `awk` is first on your `PATH`:

  ```sh
  sh tests/run.sh
  ```

- GitHub Actions runs both test scripts on Linux with gawk, mawk, BWK awk and BusyBox awk, and on macOS. A pull request needs all of them to pass.
- Document new settings in the README's Configuration table and in `greeting --help` if they add an option.

## Recording the demo

`demo.tape` records `screenshots/demo.gif`, which shows every flavor. Install [VHS](https://github.com/charmbracelet/vhs) and run:

```sh
vhs demo.tape
```
