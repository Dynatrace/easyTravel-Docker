FROM jeanblanchard/tomcat:8

LABEL maintainer="Rafal Psciuk <rafal.psciuk@dynatrace.com>, Tomasz Wieremjewicz <tomasz.wieremjewicz@dynatrace.com>"

# Deploy easyTravel Business Backend Application
COPY build/backend.war ${CATALINA_HOME}/webapps/

# The Tomcat Manager can be access using '/tomcat' context
RUN mv ${CATALINA_HOME}/webapps/ROOT ${CATALINA_HOME}/webapps/tomcat

# Make easyTravel Business Backend application base '/' context
RUN mv ${CATALINA_HOME}/webapps/backend.war ${CATALINA_HOME}/webapps/ROOT.war

ENV ET_RUNTIME_DEPS "bash curl netcat-openbsd openssl"
RUN apk add --no-cache ${ET_RUNTIME_DEPS}

RUN apk update
RUN apk add logrotate
RUN mv /etc/periodic/daily/logrotate /etc/periodic/15min/logrotate
RUN crond

COPY build/scripts/wait-for-cmd.sh /usr/local/bin
COPY build/scripts/run-process.sh /
COPY build/scripts/tomcat /etc/logrotate.d/tomcat

RUN rm /opt/tomcat/conf/logging.properties
COPY build/scripts/logging.properties /opt/tomcat/conf/logging.properties

RUN sed -i 's/prefix/rotatable=\"false\" prefix/' /opt/tomcat/conf/server.xml

EXPOSE 8080

CMD /run-process.sh
