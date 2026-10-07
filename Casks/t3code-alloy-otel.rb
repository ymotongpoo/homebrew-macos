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
           target: "#{Dir.home}/Library/LaunchAgents/homebrew.mxcl.t3code-alloy-otel.plist"

  postflight_steps do
    on_macos do
      run "/bin/sh",
          args:           [
            "-c",
            <<~SH,
              set -eu
              plist="${HOME}/Library/LaunchAgents/homebrew.mxcl.t3code-alloy-otel.plist"
              helper="{{HOMEBREW_PREFIX}}/bin/t3code-alloy-otel-env"

              /usr/bin/xattr -dr com.apple.quarantine "{{staged_path}}"
              /usr/libexec/PlistBuddy -c "Set :ProgramArguments:0 ${helper}" "${plist}"

              if /usr/bin/xattr -p com.apple.quarantine "${plist}" >/dev/null 2>&1; then
                /usr/bin/xattr -d com.apple.quarantine "${plist}"
              fi

              uid="$(/usr/bin/id -u)"
              /bin/launchctl bootstrap "gui/${uid}" "${plist}"
            SH
          ],
          writable_paths: ["~/Library/LaunchAgents"]
    end
  end

  uninstall launchctl: "homebrew.mxcl.t3code-alloy-otel",
            script:    "t3code-alloy-otel/uninstall.sh"
end
