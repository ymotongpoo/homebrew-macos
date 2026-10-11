# Casks

## t3code-alloy-otel

[`t3code-alloy-otel`](t3code-alloy-otel.rb) configures T3 Code to export OTLP traces, metrics, and logs to a local Grafana Alloy receiver at `127.0.0.1:4318` using HTTP/JSON.

Before installing, configure Grafana Alloy to receive OTLP over HTTP at that address and forward it to your telemetry backend. The cask installs a helper command and a LaunchAgent that sets the following environment variables in the user launchd session:

| Variable | Value |
| --- | --- |
| `T3CODE_OTLP_TRACES_URL` | `http://127.0.0.1:4318/v1/traces` |
| `T3CODE_OTLP_METRICS_URL` | `http://127.0.0.1:4318/v1/metrics` |
| `T3CODE_OTLP_LOGS_URL` | `http://127.0.0.1:4318/v1/logs` |
| `T3CODE_OTLP_PROTOCOL` | `http/json` |

### Install

```sh
brew install --cask ymotongpoo/macos/t3code-alloy-otel
```

Fully quit and reopen T3 Code after installation so it inherits the OTLP environment variables.

### Uninstall

```sh
brew uninstall --cask t3code-alloy-otel
```

Uninstall stops and removes the LaunchAgent, removes the helper command, and clears the four `T3CODE_OTLP_*` launchd environment variables. A T3 Code process that is already running must also be quit to stop exporting immediately.

### Publish a cask version

Run these commands from the repository root:

```sh
asset="$(scripts/package-cask.sh 0.1.3)"
shasum -a 256 "$asset"
gh release create t3code-alloy-otel-0.1.3 \
  "$asset" \
  --title "t3code-alloy-otel 0.1.3"
```

The [packaging script](../scripts/package-cask.sh) writes a deterministic archive under the system temporary directory from the files in [`support/t3code-alloy-otel`](support/t3code-alloy-otel/). Before publishing a new release, update the cask version and SHA-256 to match the archive. Replace `0.1.3` in the commands with the new version.
