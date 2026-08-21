#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT="$HOME/Documents/BEAR/youtube_channel_transcripts.py"
RUN_DIR="$(cd "$(dirname "$0")" && pwd)"
OUT_DIR="$RUN_DIR/youtube-transcripts"
LOG_FILE="$RUN_DIR/transcript-run.log"

if [[ ! -f "$SCRIPT" ]]; then
  echo "Error: transcript script not found: $SCRIPT" >&2
  exit 1
fi

channels=(
  "https://www.youtube.com/@veritasium"
  "https://www.youtube.com/@minutephysics"
  "https://www.youtube.com/@pbsspacetime"
  "https://www.youtube.com/@physicsgirl"
  "https://www.youtube.com/@kurzgesagt"
  "https://www.youtube.com/@SabineHossenfelder"
  "https://www.youtube.com/@Fermilab"
  "https://www.youtube.com/@SciShow"
  "https://www.youtube.com/@itsokaytobesmart"
  "https://www.youtube.com/@EugeneKhutoryansky"
  "https://www.youtube.com/@PerimeterInstitute"
  "https://www.youtube.com/@PhysicsWallah"
  "https://www.youtube.com/@physicsgalaxy"
  "https://www.youtube.com/@numberphile"
  "https://www.youtube.com/@3blue1brown"
  "https://www.youtube.com/@DomainOfScience"
  "https://www.youtube.com/@ElectroBOOM"
  "https://www.youtube.com/@AppliedScience"
  "https://www.youtube.com/@PracticalEngineeringChannel"
)

mkdir -p "$OUT_DIR"
cd "$RUN_DIR"

total=${#channels[@]}
for index in "${!channels[@]}"; do
  number=$((index + 1))
  channel=${channels[$index]}
  printf '\n[%s/%s] Starting %s at %s\n' \
    "$number" "$total" "$channel" "$(date '+%Y-%m-%d %H:%M:%S')" | tee -a "$LOG_FILE"

  python3 "$SCRIPT" "$channel" --out "$OUT_DIR" "$@" 2>&1 | tee -a "$LOG_FILE"

  printf '[%s/%s] Finished %s at %s\n' \
    "$number" "$total" "$channel" "$(date '+%Y-%m-%d %H:%M:%S')" | tee -a "$LOG_FILE"
done

printf '\nCompleted all %s unique channels.\n' "$total" | tee -a "$LOG_FILE"
