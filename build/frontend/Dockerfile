FROM jeanblanchard/tomcat:8

MAINTAINER Martin Etmajer <martin.etmajer@dynatrace.com>, Rafal Psciuk <rafal.psciuk@dynatrace.com>

# Deploy easyTravel Customer Frontend Application
COPY build/frontend.war ${CATALINA_HOME}/webapps/

# The Tomcat Manager can be access using '/tomcat' context
RUN mv ${CATALINA_HOME}/webapps/ROOT ${CATALINA_HOME}/webapps/tomcat

# Make easyTravel Business Backend application base '/' context
RUN mv ${CATALINA_HOME}/webapps/frontend.war ${CATALINA_HOME}/webapps/ROOT.war

ENV ET_RUNTIME_DEPS "bash netcat-openbsd"
RUN apk add --no-cache ${ET_RUNTIME_DEPS}

COPY build/scripts/wait-for-cmd.sh /usr/local/bin
COPY build/scripts/run-process.sh /

EXPOSE 8080

CMD /run-process.sh