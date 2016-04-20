FROM jeanblanchard/tomcat:8

MAINTAINER Martin Etmajer <martin.etmajer@dynatrace.com>, Rafal Psciuk <rafal.psciuk@dynatrace.com>

ENV TOMCAT_HOME /opt/tomcat

# Override easyTravel properties
ENV MONGODB_HOST mongodb

ENV CATALINA_OPTS "\
  -Dconfig.mongoDbInstances=${MONGODB_HOST}:27017 \
  -Dconfig.mongoDbUser=labuser \
  -Dconfig.mongoDbPassword=labpass"

# Deploy easyTravel Business Backend Application
COPY build/backend.war ${TOMCAT_HOME}/webapps/

# The Tomcat Manager can be access using '/tomcat' context
RUN mv ${TOMCAT_HOME}/webapps/ROOT ${TOMCAT_HOME}/webapps/tomcat

# Make easyTravel Business Backend application base '/' context
RUN mv ${TOMCAT_HOME}/webapps/backend.war ${TOMCAT_HOME}/webapps/ROOT.war

# Customize Tomcat's CATALINA_OPTS
RUN echo "CATALINA_OPTS=\"${CATALINA_OPTS} \${CATALINA_OPTS}\"" > ${TOMCAT_HOME}/bin/setenv.sh

WORKDIR ${TOMCAT_HOME}

EXPOSE 8091