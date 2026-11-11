#!/usr/bin/env bash
# gvt-wiki leak grep over tracked files. Called by the ci.yml leak-guard job and
# by .gvt-agent.json commands.validate, so the rule lives in one place and a
# violation fails the local gate, not only CI. Adapted from the gvt-dev script.
# Exits 1 on any hit.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

# Always blocked, everywhere: local filesystem paths and usernames
# are never legitimate in a committed file.
always='C:/repos/|C:/Users/|fninoles'
# Exclude the files that define the pattern above, which would self-match.
guard=(':!.github/workflows/ci.yml' ':!.github/scripts/leak-guard.sh')
found=0
# xargs exits 123 when every grep finds nothing, which is the clean case.
if git ls-files -z -- "${guard[@]}" | xargs -0 grep -nE "$always"; then
  echo "::error::leak pattern found (local path / username - blocked everywhere)"
  found=1
fi
if [ "$found" -ne 0 ]; then exit 1; fi
echo "no leak patterns found"
