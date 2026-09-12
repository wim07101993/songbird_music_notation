#!/usr/bin/env bash
# Runs pana on a package and fails when its score is below a minimum.
#
#   tool/ensure_pana_score.sh packages/songbird_score
#   tool/ensure_pana_score.sh packages/songbird_score 160
#
# Without a minimum, the package has to score full marks. The score pana
# reports is the one pub.dev will show, so a drop here is a drop the world sees.
#
# pana is pointed at a copy of the package with its symlinks resolved, not at
# the package itself. Each package's analysis_options.yaml is a link to the one
# at the root of the repository; `dart pub publish` follows it and writes a real
# file into the archive, but pana copies the directory link and all, and a link
# reaching out of the copy dangles. The formatter settings are lost with it, and
# twenty perfectly good files get reported as badly formatted. Resolving the
# links first is what makes this score the one pub.dev computes from the
# uploaded archive. `--project-root` does not help; it was tried.
set -euo pipefail

package="${1:?usage: ensure_pana_score.sh <package-dir> [minimum]}"
name="$(basename "$package")"

work="$(mktemp -d)"
report="$(mktemp)"
trap 'rm -rf "$work" "$report"' EXIT

# Everything but the two directories that hold build output: they are large,
# they are not published, and pana has no use for them.
mkdir -p "$work/$name"
for entry in "$package"/* "$package"/.[!.]*; do
  [[ -e "$entry" ]] || continue
  case "$(basename "$entry")" in
    .dart_tool | build) continue ;;
  esac
  cp -rL "$entry" "$work/$name/"
done

pana --no-warning --json "$work/$name" >"$report"

granted="$(jq -r '.scores.grantedPoints' "$report")"
max="$(jq -r '.scores.maxPoints' "$report")"
minimum="${2:-$max}"

# Every section that left points on the table, with the explanation pana gave.
jq -r '
  .report.sections[]
  | select(.grantedPoints < .maxPoints)
  | "── \(.title): \(.grantedPoints)/\(.maxPoints)\n\(.summary)\n"
' "$report"

echo "score: $granted/$max (minimum $minimum)"

if ((granted < minimum)); then
  echo "::error::$package scored $granted, below the minimum of $minimum"
  exit 1
fi
