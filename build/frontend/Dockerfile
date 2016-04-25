FROM jeanblanchard/tomcat:8

MAINTAINER Martin Etmajer <martin.etmajer@dynatrace.com>, Rafal Psciuk <rafal.psciuk@dynatrace.com>

ENV TOMCAT_HOME /opt/tomcat

# Deploy easyTravel Customer Frontend Application
COPY build/frontend.war ${TOMCAT_HOME}/webapps/

# The Tomcat Manager can be access using '/tomcat' context
RUN mv ${TOMCAT_HOME}/webapps/ROOT ${TOMCAT_HOME}/webapps/tomcat

# Make easyTravel Business Backend application base '/' context
RUN mv ${TOMCAT_HOME}/webapps/frontend.war ${TOMCAT_HOME}/webapps/ROOT.war

WORKDIR ${TOMCAT_HOME}

EXPOSE 8080