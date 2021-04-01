#!/bin/bash
ET_BACKEND_URL=${ET_BACKEND_URL:-'http://localhost:8080'}

# Wait for the backend to start serving connections.
echo "Waiting for the easyTravel Business Backend on ${ET_BACKEND_URL}"
wait-for-cmd.sh "nc -z `echo ${ET_BACKEND_URL} | sed 's/http:\/\///' | sed 's/:/ /'`" 360

${CATALINA_HOME}/bin/catalina.sh run
