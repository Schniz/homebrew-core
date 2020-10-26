class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https://fnm.vercel.app"
  url "https://github.com/Schniz/fnm/archive/v1.22.2.tar.gz"
  sha256 "49013376359a1e0d690359b10c09604df90ab30602e8400acf0a97d241707344"
  license "GPL-3.0-only"
  head "https://github.com/Schniz/fnm.git"

  livecheck do
    url "https://github.com/Schniz/fnm/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    (bash_completion/"fnm").write Utils.safe_popen_read("#{bin}/fnm completions --shell bash")
    (fish_completion/"fnm.fish").write Utils.safe_popen_read("#{bin}/fnm completions --shell fish")
    (zsh_completion/"_fnm").write Utils.safe_popen_read("#{bin}/fnm completions --shell zsh")
  end

  def caveats
    <<~CAVEATS
      Thanks for installing fnm!
      The last step for making fnm work is to run it on the shell startup, using the `fnm env` command.

      In order to complete the installation, please add the following to your shell profile:

        # fnm
        #{source_for_shell}

      Homebrew tells us that #{preferred} is your preferred shell,
      and your shell profile is at #{shell_profile.inspect}, if that helps 😇
    CAVEATS
  end

  test do
    system("#{bin}/fnm", "install", "12.0.0")
    assert_match "v12.0.0", shell_output("#{bin}/fnm exec --using=12.0.0 -- node --version")
  end

  def source_for_shell
    if preferred == :fish
      "fnm env --multi | source"
    else
      'eval "$(fnm env --multi)"'
    end
  end
end
