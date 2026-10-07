cask "t3code-alloy-otel" do
  version "0.1.3"
  sha256 "f1671ce0eb0b5dfdccdc84cf9c4b2cf432a35dd059ee31a6d7b2fc495388e6c7"

  url "https://github.com/ymotongpoo/homebrew-macos/releases/download/t3code-alloy-otel-#{version}/t3code-alloy-otel-#{version}.tar.gz"
  name "T3 Code Alloy OTLP Environment"
  desc "Configure T3 Code to export OTLP telemetry through local Grafana Alloy"
  homepage "https://github.com/pingdotgg/t3code"

  depends_on :macos

  binary "t3code-alloy-otel/t3code-alloy-otel-env"
  artifact "t3code-alloy-otel/homebrew.mxcl.t3code-alloy-otel.plist",
           target: "#{ENV["HOME"]}/Library/LaunchAgents/homebrew.mxcl.t3code-alloy-otel.plist"

  postflight do
    plist = "#{ENV["HOME"]}/Library/LaunchAgents/homebrew.mxcl.t3code-alloy-otel.plist"
    helper = "#{ENV.fetch("HOMEBREW_PREFIX")}/bin/t3code-alloy-otel-env"

    system_command "/usr/bin/xattr",
                    args: ["-dr", "com.apple.quarantine", staged_path],
                    must_succeed: true
    system_command "/usr/libexec/PlistBuddy",
                    args: ["-c", "Set :ProgramArguments:0 #{helper}", plist],
                    must_succeed: true
    remove_quarantine = <<~SH
      if /usr/bin/xattr -p com.apple.quarantine "$1" >/dev/null 2>&1; then
        /usr/bin/xattr -d com.apple.quarantine "$1"
      fi
    SH
    system_command "/bin/sh",
                    args: ["-c", remove_quarantine, "sh", plist]
    system_command "/bin/launchctl",
                    args: ["bootstrap", "gui/#{Process.uid}", plist],
                    must_succeed: true
  end

  uninstall launchctl: "homebrew.mxcl.t3code-alloy-otel",
            script:   "t3code-alloy-otel/uninstall.sh"
end
