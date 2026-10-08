class ActivitylogAgent < Formula
  desc "Send desktop activity to Grafana Cloud over OTLP"
  homepage "https://github.com/ymotongpoo/activitylog"
  url "https://github.com/ymotongpoo/activitylog/releases/download/v0.2.0/activitylog-agent-0.2.0-darwin-universal.tar.gz"
  sha256 "89530ce8b1de752b83607cbda17ae6312bd118e5ae95e0d80c15096cad199e10"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on :macos

  def install
    bin.install "activitylog-agent"
  end

  def caveats
    <<~EOS
      Write a configuration, then start the agent:
        mkdir -p ~/Library/Application\\ Support/activitylog
        activitylog-agent example-config > ~/Library/Application\\ Support/activitylog/config.yaml
        # edit otlp.endpoint, otlp.instance_id and the token
        brew services start activitylog-agent

      Grant Accessibility (and Automation for browsers without the extension)
      to activitylog-agent in System Settings > Privacy & Security. The binary
      is ad-hoc signed, so grant them again after each upgrade.
    EOS
  end

  service do
    run [opt_bin/"activitylog-agent", "run"]
    keep_alive successful_exit: false
    process_type :interactive
    log_path var/"log/activitylog-agent.log"
    error_log_path var/"log/activitylog-agent.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/activitylog-agent version")
    assert_match "otlp:", shell_output("#{bin}/activitylog-agent example-config")
  end
end
