# Formula

## activitylog-agent

[`activitylog-agent`](activitylog-agent.rb) is a background daemon that collects desktop activity, including the foreground app, window title, AFK state, browser tab, editor file, and shell commands. It sends activity over OTLP to a local Grafana Alloy or OpenTelemetry Collector, which can forward it to Grafana Cloud.

This formula requires an Apple Silicon Mac. See the [activitylog README](https://github.com/ymotongpoo/activitylog) for collector configuration and usage details.

### Install and configure

```sh
brew install ymotongpoo/macos/activitylog-agent
```

The default OTLP endpoint is `http://localhost:4318`. To customize the configuration, generate an example and edit it before starting the service:

```sh
mkdir -p ~/Library/Application\ Support/activitylog
activitylog-agent example-config > ~/Library/Application\ Support/activitylog/config.yaml
```

Grant Accessibility permission to `activitylog-agent` in **System Settings > Privacy & Security**. Grant Automation permission for browsers used without the extension. The binary is ad-hoc signed, so grant these permissions again after each upgrade.

### Manage the service

```sh
brew services start activitylog-agent
brew services stop activitylog-agent
```

The service writes its logs to `$(brew --prefix)/var/log/activitylog-agent.log`.

### Uninstall

```sh
brew services stop activitylog-agent
brew uninstall activitylog-agent
```
