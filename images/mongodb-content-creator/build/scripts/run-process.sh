#!/bin/bash
ET_DATABASE_LOCATION=${ET_DATABASE_LOCATION:-'localhost:27017'}

# Wait for the database to start serving connections.
echo "Waiting for the easyTravel database on ${ET_DATABASE_LOCATION}"
wait-for-cmd.sh "nc -z `echo ${ET_DATABASE_LOCATION} | sed 's/:/ /'`" 360

java ${JAVA_OPTS} -cp com.dynatrace.easytravel.launcher.jar -Dconfig.mongoDbInstances=${ET_DATABASE_LOCATION} -Dconfig.mongoDbUser=${ET_MONGODB_USER} -Dconfig.mongoDbAuthDatabase=${ET_MONGODB_AUTH_DB} -Dconfig.mongoDbPassword=${ET_MONGODB_PASSWORD} com.dynatrace.easytravel.launcher.war.DatabaseContentCreator mongod	b
