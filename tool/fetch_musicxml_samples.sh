#!/usr/bin/env bash
# Fetches the official MusicXML sample set into samples/, which is not tracked.
#
# The files are the ones at https://www.musicxml.com/music-in-musicxml/example-set/
# — Dichterliebe, the Mozart trio, Debussy, a Telemann canon and the rest. They
# are the best thing to test a reader against, because they are what the format
# was demonstrated with and they use corners of it that a generated score never
# will.
#
# They are not in this repository on purpose. The page carries MakeMusic's
# copyright and says the copyright holders gave permission to include the
# samples *on that site*; that is permission to host, not permission to pass
# on. Fetching them for your own use is fine, so this does that and leaves them
# out of git.
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
target="$root/samples"
base="https://wpmedia.musicxml.com/wp-content/uploads/2021/06"

names=(
  ActorPreludeSample
  BeetAnGeSample
  Binchois
  BrahWiMeSample
  BrookeWestSample
  Chant
  DebuMandSample
  Dichterliebe01
  Echigo-Jishi
  FaurReveSample
  MahlFaGe4Sample
  MozaChloSample
  MozaVeilSample
  MozartPianoSonata
  MozartTrio
  Saltarello
  SchbAvMaSample
  Telemann
)

mkdir -p "$target"
for name in "${names[@]}"; do
  out="$target/$name.musicxml"
  if [[ -s "$out" ]]; then
    echo "have  $name"
    continue
  fi
  echo "fetch $name"
  curl -fsSL --retry 2 -A 'songbird-music-notation sample fetcher' \
    -o "$out" "$base/$name.musicxml" || {
      echo "  could not fetch $name" >&2
      rm -f "$out"
    }
done

echo
echo "Fetched into $target"
find "$target" -iname '*.musicxml' | sort | sed 's|^|  |'
echo
echo "Open one from the example with the folder button."
