class NutritionRs < Formula
  desc "A CLI for flexible plaintext nutrition tracking"
  homepage "https://github.com/jafayer/nutrition-rs"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/jafayer/nutrition-rs/releases/download/v0.1.3/nutrition_rs-aarch64-apple-darwin.tar.xz"
      sha256 "4f51f8a9e5e6d26fc7c55c237316a8e586611af0465aecf40595822ce1287b90"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jafayer/nutrition-rs/releases/download/v0.1.3/nutrition_rs-x86_64-apple-darwin.tar.xz"
      sha256 "2cccabfd00918544fb681e4ae889e2efd6f4a76c95a218946d6eeb476f3d977b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jafayer/nutrition-rs/releases/download/v0.1.3/nutrition_rs-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1e04d53d337bdee1124112abd0377e48076268c5d572af20651e052171c62a8c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jafayer/nutrition-rs/releases/download/v0.1.3/nutrition_rs-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "39278a370d8b7534bfa49394cca7f493f6c856e263b1d7b58035dc5d83bc451b"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "nutrition" if OS.mac? && Hardware::CPU.arm?
    bin.install "nutrition" if OS.mac? && Hardware::CPU.intel?
    bin.install "nutrition" if OS.linux? && Hardware::CPU.arm?
    bin.install "nutrition" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
