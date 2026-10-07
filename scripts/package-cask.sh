#!/bin/sh
set -eu

version="${1:?usage: scripts/package-cask.sh VERSION}"
case "${version}" in
  *[!0-9.]* | '')
    printf 'version must contain only digits and dots\n' >&2
    exit 2
    ;;
  *)
    :
    ;;
esac
script_dir="$(CDPATH='' cd -- "$(dirname -- "${0}")" && pwd)"
repo_root="$(CDPATH='' cd -- "${script_dir}/.." && pwd)"
output="${TMPDIR:-/tmp}/t3code-alloy-otel-${version}.tar.gz"

python3 - "${repo_root}" "${output}" <<'PY'
import gzip
import pathlib
import sys
import tarfile

repo = pathlib.Path(sys.argv[1])
out = pathlib.Path(sys.argv[2])
source = repo / "Casks" / "support" / "t3code-alloy-otel"
files = sorted(path for path in source.iterdir() if path.is_file())
with out.open("wb") as raw:
    with gzip.GzipFile(filename="", mode="wb", fileobj=raw, mtime=0) as compressed:
        with tarfile.open(fileobj=compressed, mode="w", format=tarfile.PAX_FORMAT) as archive:
            for path in files:
                relative = pathlib.PurePosixPath("t3code-alloy-otel") / path.name
                info = archive.gettarinfo(str(path), arcname=str(relative))
                info.uid = 0
                info.gid = 0
                info.uname = ""
                info.gname = ""
                info.mtime = 0
                with path.open("rb") as content:
                    archive.addfile(info, content)
print(out)
PY
