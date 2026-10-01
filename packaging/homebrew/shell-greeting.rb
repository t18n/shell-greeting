# Homebrew formula for the t18n/taps tap (github.com/t18n/homebrew-taps, as Formula/shell-greeting.rb).
# The release steps in CONTRIBUTING.md say how to fill in url and sha256 for each version.
class ShellGreeting < Formula
  desc "Random quote with ASCII, pixel, braille or image art for every new terminal"
  homepage "https://github.com/t18n/shell-greeting"
  url "https://github.com/t18n/shell-greeting/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "REPLACE_WITH_THE_SHA256_OF_THE_RELEASE_TARBALL"
  license "MIT"

  def install
    # greeting finds quotes/ and graphics/ next to itself, so it lives in libexec with them
    # and bin/greeting is a small wrapper that runs it there.
    libexec.install "greeting", "quotes", "graphics"
    bin.write_exec_script libexec/"greeting"
  end

  def caveats
    <<~EOS
      To see a greeting in every new terminal, add this line to your shell's
      startup file (~/.zshrc, ~/.bashrc or ~/.config/fish/config.fish):
        greeting

      For the image flavor, also install chafa:
        brew install chafa
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/greeting --version")
    assert_match "total", shell_output("#{bin}/greeting --list")
  end
end
