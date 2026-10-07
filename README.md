# T3 Code Alloy OTLP Homebrew tap

This tap configures T3 Code to export OTLP traces, metrics, and logs to a local Grafana Alloy receiver at `127.0.0.1:4318`.

## Install

```sh
brew tap <github-owner>/t3code
brew install --cask t3code-alloy-otel
```

Fully quit and reopen T3 Code after installation so it inherits the OTLP environment variables.

## Uninstall

```sh
brew uninstall --cask t3code-alloy-otel
```

Uninstall stops and removes the LaunchAgent, removes the helper command, and clears the four `T3CODE_OTLP_*` launchd environment variables. A T3 Code process that is already running must also be quit to stop exporting immediately.

## Publish a cask version

```sh
asset="$(scripts/package-cask.sh 0.1.0)"
shasum -a 256 "$asset"
gh release create t3code-alloy-otel-0.1.0 \
  "$asset" \
  --title "t3code-alloy-otel 0.1.0"
```

The script writes a deterministic archive under the system temporary directory. Before publishing a new release, update the cask version and SHA-256 to match the archive. Replace `0.1.0` in the commands with the new version.
