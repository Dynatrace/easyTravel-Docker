#!/bin/bash
ET_DATABASE_LOCATION=${ET_DATABASE_LOCATION:-'localhost:27017'}

# Wait for the database to start serving connections.
echo "Waiting for the easyTravel database on ${ET_DATABASE_LOCATION}"
wait-for-cmd.sh "nc -z `echo ${ET_DATABASE_LOCATION} | sed 's/:/ /'`" 360

${CATALINA_HOME}/bin/catalina.sh run