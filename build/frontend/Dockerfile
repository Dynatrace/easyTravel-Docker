FROM jeanblanchard/tomcat:8

MAINTAINER Martin Etmajer <martin.etmajer@dynatrace.com>, Rafal Psciuk <rafal.psciuk@dynatrace.com>

ENV TOMCAT_HOME /opt/tomcat

# Override easyTravel properties
ENV BACKEND_HOST backend

ENV CATALINA_OPTS "-Dconfig.webServiceBaseDir=http://${BACKEND_HOST}:8080/services/"

# Deploy easyTravel Customer Frontend Application
COPY build/frontend.war ${TOMCAT_HOME}/webapps/

# The Tomcat Manager can be access using '/tomcat' context
RUN mv ${TOMCAT_HOME}/webapps/ROOT ${TOMCAT_HOME}/webapps/tomcat

# Make easyTravel Business Backend application base '/' context
RUN mv ${TOMCAT_HOME}/webapps/frontend.war ${TOMCAT_HOME}/webapps/ROOT.war

# Customize Tomcat's CATALINA_OPTS
RUN echo "CATALINA_OPTS=\"${CATALINA_OPTS} \${CATALINA_OPTS}\"" > ${TOMCAT_HOME}/bin/setenv.sh

WORKDIR ${TOMCAT_HOME}

EXPOSE 8080