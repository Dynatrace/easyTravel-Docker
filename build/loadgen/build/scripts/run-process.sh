#!/bin/bash
ET_FRONTEND_URL=${ET_FRONTEND_URL:-'http://localhost:8080'}
ET_PROBLEMS_DELAY=${ET_PROBLEMS_DELAY:-0}

if [ -n "${ET_BACKEND_URL}" ]; then
  echo "Waiting for the easyTravel Business Backend on ${ET_BACKEND_URL}"
  wait-for-cmd.sh "nc -z `echo ${ET_BACKEND_URL} | sed 's/http:\/\///' | sed 's/:/ /'`" 360
  (sleep ${ET_PROBLEMS_DELAY} && run-problem-patterns.sh) &
fi

echo "Waiting for the easyTravel Customer Frontend on ${ET_FRONTEND_URL}"
wait-for-cmd.sh "nc -z `echo ${ET_FRONTEND_URL} | sed 's/http:\/\///' | sed 's/:/ /'`" 360
java -jar uemload.jar --autorun true --server ${ET_FRONTEND_URL}