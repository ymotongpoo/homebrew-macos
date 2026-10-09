class ActivitylogAgent < Formula
  desc "Send desktop activity to Grafana Cloud over OTLP"
  homepage "https://github.com/ymotongpoo/activitylog"
  url "https://github.com/ymotongpoo/activitylog/releases/download/v0.6.2/activitylog-agent-0.6.2-darwin-arm64.tar.gz"
  sha256 "b7c83d7520aa24cc840688f175714f56c82da6fd28515195d0314edd12e79454"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on :macos

  def install
    bin.install "activitylog-agent"
  end

  def caveats
    <<~EOS
      The agent sends OTLP to http://localhost:4318, the default receiver of a
      local Grafana Alloy or OpenTelemetry Collector. To change it, write a
      configuration first:
        mkdir -p ~/Library/Application\\ Support/activitylog
        activitylog-agent example-config > ~/Library/Application\\ Support/activitylog/config.yaml

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
