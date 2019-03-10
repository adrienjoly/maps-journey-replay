#!/usr/bin/env bash

echo "Waiting for HTTP server to be ready..."
npx http-server &
PID=$!
sleep 3

echo "Opening demo in browser..."
open http://localhost:8080/demo/journey-replay.html

echo "Will kill HTTP server in 3 seconds..."
sleep 3
kill $PID
