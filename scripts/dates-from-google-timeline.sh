#!/usr/bin/env bash
#
# This script prints the dates covered by location history exported from
# Google Takeout.
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

INPUT_FILE='Location History.json'

# Generate a JSON file that only returns the location history for that range:

jq '.locations[] | ((.timestampMs|tonumber) / 1000) | todate' "${INPUT_FILE}"
