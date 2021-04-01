FROM tomcat:8.5-jdk11-openjdk

LABEL maintainer="Rafal Psciuk <rafal.psciuk@dynatrace.com>, Tomasz Wieremjewicz <tomasz.wieremjewicz@dynatrace.com>"

# Deploy easyTravel Business Backend Application
COPY build/PluginService.war ${CATALINA_HOME}/webapps/

ENV ET_RUNTIME_DEPS "bash curl openssl"
RUN apt-get update && apt-get install -y ${ET_RUNTIME_DEPS}

COPY build/scripts/run-process.sh /
COPY build/scripts/fix-permissions.sh /

RUN rm /usr/local/tomcat/conf/logging.properties
COPY build/scripts/logging.properties /usr/local/tomcat/conf/logging.properties

RUN /fix-permissions.sh /usr/local/tomcat/*
RUN sed -i 's/prefix/maxDays="2" prefix/' /usr/local/tomcat/conf/server.xml
RUN sed -i 's,</Host>,  <Valve className="org.apache.catalina.valves.ErrorReportValve" \n               showReport="false" showServerInfo="false"/>\n      </Host>,' /usr/local/tomcat/conf/server.xml

EXPOSE 8080

CMD /run-process.sh
