class Linkjumper < Formula
  desc "Local URL shortener for macOS — type go/gh instead of https://github.com"
  homepage "https://github.com/peterfrench/linkjumper"
  url "https://github.com/peterfrench/linkjumper/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "7ec4cfc50d3c91cc591dbec4ef57b9c13c5b191db198256d03cfbe2772f504f2"
  license "MIT"

  depends_on :macos
  depends_on "python@3"

  def install
    # Install the Python package into libexec
    libexec.install "linkjumper", "pyproject.toml"

    # Create wrapper scripts that set PYTHONPATH so the package is importable
    (bin/"linkjumper").write <<~EOS
      #!/bin/bash
      PYTHONPATH="#{libexec}" exec "#{Formula["python@3"].opt_bin}/python3" -m linkjumper "$@"
    EOS

    (bin/"linkj").write <<~EOS
      #!/bin/bash
      PYTHONPATH="#{libexec}" exec "#{Formula["python@3"].opt_bin}/python3" -m linkjumper "$@"
    EOS
  end

  def post_install
    ohai "Run `sudo linkjumper setup` to configure your system"
  end

  def caveats
    <<~EOS
      To complete installation, run:
        sudo linkjumper setup

      This configures /etc/hosts, SSL certificates, and the launchd service.

      Data is stored in /usr/local/etc/linkjumper/ (override with LINKJUMPER_DATA_DIR).
    EOS
  end

  test do
    assert_match "LinkJumper", shell_output("#{bin}/linkjumper --help")
  end
end
