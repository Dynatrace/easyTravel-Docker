#!/bin/bash
ET_WWW_URL=${ET_WWW_URL:-'http://localhost:80'}

# Wait for the server to start serving connections.
echo "Waiting for the easyTravel Customer Frontend on ${ET_WWW_URL}"
wait-for-cmd.sh "nc -z `echo ${ET_WWW_URL} | sed 's/http:\/\///' | sed 's/:/ /'`" 360

run-problem-patterns.sh &
java -jar uemload.jar --autorun true --server ${ET_WWW_URL}