#!/bin/bash
ET_DATABASE_LOCATION=${ET_DATABASE_LOCATION:-'localhost:27017'}

# Wait for the database to start serving connections.
echo "Waiting for the easyTravel database on ${ET_DATABASE_LOCATION}"
wait-for-cmd.sh "nc -z `echo ${ET_DATABASE_LOCATION} | sed 's/:/ /'`" 360

java ${JAVA_OPTS} -cp com.dynatrace.easytravel.launcher.jar -Dconfig.mongoDbInstances=${ET_DATABASE_LOCATION} -Dconfig.mongoDbUser=${ET_DATABASE_USER} -Dconfig.mongoDbAuthDatabase=${ET_MONGO_AUTH_DB} -Dconfig.mongoDbPassword=${ET_DATABASE_PASSWORD} com.dynatrace.easytravel.launcher.war.DatabaseContentCreator mongodb
