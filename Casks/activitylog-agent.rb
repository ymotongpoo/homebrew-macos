cask "activitylog-agent" do
  version "0.1.0"
  sha256 "4cea033b2387199188f2bcf35a32cb1ee61c93d72e968d746dae336f71825393"

  url "https://github.com/ymotongpoo/activitylog/releases/download/v#{version}/ActivityLogAgent-#{version}-macos-universal.zip"
  name "ActivityLog Agent"
  desc "Send desktop activity to Grafana Cloud over OTLP"
  homepage "https://github.com/ymotongpoo/activitylog"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "ActivityLogAgent.app"
  binary "#{appdir}/ActivityLogAgent.app/Contents/MacOS/activitylog-agent"

  # The app is ad-hoc signed and not notarized. Restart the agent if it is
  # already registered so that an upgrade takes effect.
  postflight_steps do
    on_macos do
      run "/bin/sh",
          args: [
            "-c",
            <<~SH,
              set -eu
              /usr/bin/xattr -dr com.apple.quarantine "{{appdir}}/ActivityLogAgent.app" 2>/dev/null || true
              target="gui/$(/usr/bin/id -u)/net.ymotongpoo.activitylog.agent"
              if /bin/launchctl print "${target}" >/dev/null 2>&1; then
                /bin/launchctl kickstart -k "${target}"
              fi
            SH
          ]
    end
  end

  uninstall launchctl: "net.ymotongpoo.activitylog.agent"

  zap trash: [
    "~/Library/Application Support/activitylog",
    "~/Library/Logs/activitylog-agent.log",
  ]

  caveats <<~EOS
    Write a configuration and start the agent:

      mkdir -p ~/Library/Application\\ Support/activitylog
      activitylog-agent example-config > ~/Library/Application\\ Support/activitylog/config.yaml
      # edit otlp.endpoint, otlp.instance_id and the token
      activitylog-agent service install

    Grant Accessibility (and Automation for browsers without the extension)
    to ActivityLog Agent in System Settings > Privacy & Security.
    The app is ad-hoc signed, so grant them again after each upgrade.
  EOS
end
