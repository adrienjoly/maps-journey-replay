#!/usr/bin/env bash
#
# This script converts a location history exported from Google Takeout
# into a JSON file that can be read by maps-journey-replay.
#
# It requires `jq` that you can install on macOS using `$ brew install jq`.
#
# First, download "Location History" from:
# https://takeout.google.com/settings/takeout?hl=en&gl=EN&expflags
#
# => Big "Location history.json" file that looks like that:
# 
# {
#   "locations": [
#     {  "timestampMs": "1546415889121" ... },
#     {  "timestampMs": "1546415725521" ... } 
#   ]
# }

# Specify your date/time range below:

START_TIME='2017-09-01T6:00:00Z'
END_TIME='2017-09-04T15:00:00Z'
INPUT_FILE='Location History.json'
TMP_FILE='filtered.json'
OUTPUT_FILE='journey.json'

# Generate a JSON file that only returns the location history for that range:

echo "Generate ${TMP_FILE} from ${INPUT_FILE} ..."

cat "${INPUT_FILE}" | jq --arg s ${START_TIME} --arg e ${END_TIME} '
  [($s, $e) | fromdate] as $r |
    [ .locations[] |
      select(
        (.timestampMs|tonumber) >= ($r[0] * 1000) and
        (.timestampMs|tonumber) <= ($r[1] * 1000)
      )
    ]' > "${TMP_FILE}"

# Convert it to a simpler "journey" format:

echo "Convert ${TMP_FILE} to ${OUTPUT_FILE} ..."

cat "${TMP_FILE}" | jq '[ .[] | {
  timestamp: .timestampMs|tonumber,
  lat: (.latitudeE7 / 10000000),
  lng: (.longitudeE7 / 10000000)
 } ] | reverse' > "${OUTPUT_FILE}"

echo "✅ Generated ${OUTPUT_FILE}."
