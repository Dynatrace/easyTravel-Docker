FROM tomcat:8.5-jdk11-openjdk

LABEL maintainer="Rafal Psciuk <rafal.psciuk@dynatrace.com>, Tomasz Wieremjewicz <tomasz.wieremjewicz@dynatrace.com>"

# Deploy easyTravel Customer Frontend Application
COPY build/angularFrontend.war ${CATALINA_HOME}/webapps/

# Make easyTravel Business Backend application base '/' context
RUN mv ${CATALINA_HOME}/webapps/angularFrontend.war ${CATALINA_HOME}/webapps/ROOT.war

ENV ET_RUNTIME_DEPS "bash curl netcat-openbsd openssl"
RUN apt-get update && apt-get install -y ${ET_RUNTIME_DEPS}

COPY build/scripts/wait-for-cmd.sh /usr/local/bin
COPY build/scripts/run-process.sh /
COPY build/scripts/fix-permissions.sh /

RUN rm /usr/local/tomcat/conf/logging.properties
COPY build/scripts/logging.properties /usr/local/tomcat/conf/logging.properties

RUN /fix-permissions.sh /usr/local/tomcat/*
RUN sed -i 's/prefix/maxDays="2" prefix/' /usr/local/tomcat/conf/server.xml
RUN sed -i 's,</Host>,  <Valve className="org.apache.catalina.valves.ErrorReportValve" \n               showReport="false" showServerInfo="false"/>\n      </Host>,' /usr/local/tomcat/conf/server.xml

EXPOSE 8080

CMD /run-process.sh
