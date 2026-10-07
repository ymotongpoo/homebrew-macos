#!/bin/sh
set -eu
/bin/launchctl unsetenv T3CODE_OTLP_TRACES_URL
/bin/launchctl unsetenv T3CODE_OTLP_METRICS_URL
/bin/launchctl unsetenv T3CODE_OTLP_LOGS_URL
/bin/launchctl unsetenv T3CODE_OTLP_PROTOCOL
