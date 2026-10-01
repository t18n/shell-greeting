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

## Releasing

1. Set `VERSION` near the top of `greeting` and add an entry to `CHANGELOG.md`, then commit.
2. Tag and push:

   ```sh
   git tag -a v1.2.3 -m "shell-greeting 1.2.3"
   git push --follow-tags
   ```

3. Get the checksum of the release download:

   ```sh
   curl -sL https://github.com/t18n/shell-greeting/archive/refs/tags/v1.2.3.tar.gz | shasum -a 256
   ```

4. In `packaging/homebrew/shell-greeting.rb`, update `url` to the new tag and `sha256` to that checksum. Copy the file to the tap repository, [`t18n/homebrew-taps`](https://github.com/t18n/homebrew-taps), as `Formula/shell-greeting.rb`, and push. After the first release, the install command is `brew install t18n/taps/shell-greeting`.
