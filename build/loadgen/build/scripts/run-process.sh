#!/bin/bash
ET_FRONTEND_URL=${ET_FRONTEND_URL:-'http://localhost:8080'}

# Wait for the server to start serving connections.
echo "Waiting for the easyTravel Customer Frontend on ${ET_FRONTEND_URL}"
wait-for-cmd.sh "nc -z `echo ${ET_FRONTEND_URL} | sed 's/http:\/\///' | sed 's/:/ /'`" 360

if [ -n "${ET_BACKEND_URL}" ]; then
  echo "Waiting for the easyTravel Business Backend on ${ET_BACKEND_URL}"
  wait-for-cmd.sh "nc -z `echo ${ET_BACKEND_URL} | sed 's/http:\/\///' | sed 's/:/ /'`" 360
  run-problem-patterns.sh &
fi

java -jar uemload.jar --autorun true --server ${ET_FRONTEND_URL}