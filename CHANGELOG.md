# Changelog

## 1.0.0 - 2026-10-01

The first release.

- Four flavors, each with its own look: `art` (113 ASCII graphics in a classic cowsay bubble with a rainbow), `pixel` (16 pixel-art sprites), `braille` (16 braille line drawings) and `image` (20 illustrations, shown with chafa or iTerm2).
- 186 quotes in 7 topics: programming, innovation, business, startups, science, wisdom and humor.
- A time-of-day greeting, one random fact about the day or the computer, rare shiny greetings, holiday characters and a late-night nudge.
- Settings as `GREETING_*` environment variables, including the flavor and how often each one comes up, quote topics, your own content folders and a frequency limit.
- `--flavor`, `--list`, `--force`, `--help` and `--version`.
- `NO_COLOR` support, and no output when the output is not a terminal.
- Converters that turn pictures into pixel and braille art.
- Skills for AI agents that add quotes and graphics following the content rules.
- Tests for the content and the behavior, run on Linux with four awk versions and on macOS.
