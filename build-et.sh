#!/bin/bash
set -e

ET_SRC_URL=${ET_SRC_URL:-"http://etinstallers.demoability.dynatracelabs.com/latest/dynatrace-easytravel-src.zip"}
ET_SRC_HOME=/tmp
ET_SRC_CF_HOME="${ET_SRC_HOME}/CustomerFrontend"
ET_SRC_BB_HOME="${ET_SRC_HOME}/BusinessBackend"
ET_SRC_LG_HOME="${ET_SRC_HOME}/com.dynatrace.uemload"

ET_DEPLOY_HOME="${ET_DEPLOY_HOME:-$(pwd)/deploy}"
ET_CF_DEPLOY_HOME="${ET_DEPLOY_HOME}/${ET_CF_DEPLOY_HOME:-frontend}"
ET_ACF_DEPLOY_HOME="${ET_DEPLOY_HOME}/${ET_ACF_DEPLOY_HOME:-angularfrontend}"
ET_BB_DEPLOY_HOME="${ET_DEPLOY_HOME}/${ET_BB_DEPLOY_HOME:-backend}"
ET_LG_DEPLOY_HOME="${ET_DEPLOY_HOME}/${ET_LG_DEPLOY_HOME:-loadgen}"
ET_HLG_DEPLOY_HOME="${ET_DEPLOY_HOME}/${ET_HLG_DEPLOY_HOME:-headlessloadgen}"
ET_MG_DEPLOY_HOME="${ET_DEPLOY_HOME}/${ET_MG_DEPLOY_HOME:-mongodb}"
ET_MGC_DEPLOY_HOME="${ET_DEPLOY_HOME}/${ET_MGC_DEPLOY_HOME:-mongodb-content-creator}"
ET_PS_DEPLOY_HOME="${ET_DEPLOY_HOME}/${ET_PS_DEPLOY_HOME:-pluginservice}"
ET_CF_DEPLOY_LIB_HOME="${ET_CF_DEPLOY_HOME}/lib"

cd "${ET_SRC_HOME}"

# Download easyTravel sources
echo "EasyTravel source: ${ET_SRC_URL}"
curl -L -o easyTravel-src.zip "${ET_SRC_URL}"

# Unarchive and build easyTravel sources while setting up some env vars
unzip ./easyTravel-src.zip
export ANT_OPTS="-Dfile.encoding=UTF8"
export JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8
ant -f ./Distribution war
cd "${ET_SRC_HOME}/Distribution/dist"

# Deploy easyTravel build artifacts into the workspace
mkdir -p "${ET_BB_DEPLOY_HOME}"
cp -v ./business/backend.war ${ET_BB_DEPLOY_HOME}

mkdir -p "${ET_CF_DEPLOY_HOME}"
cp -v ./customer/frontend.war ${ET_CF_DEPLOY_HOME}

mkdir -p "${ET_ACF_DEPLOY_HOME}"
cp -v ./angular/angularFrontend.war ${ET_ACF_DEPLOY_HOME}

mkdir -p "${ET_PS_DEPLOY_HOME}"
cp -v ./pluginservice/PluginService.war ${ET_PS_DEPLOY_HOME}

mkdir -p "${ET_MG_DEPLOY_HOME}"
cp -v ${ET_SRC_HOME}/ThirdPartyLibraries/MongoDB/data/easyTravel-mongodb-db.tar.gz ${ET_MG_DEPLOY_HOME}

mkdir -p "${ET_LG_DEPLOY_HOME}"
tar -cvzf "${ET_LG_DEPLOY_HOME}/loadgen.tar.gz" \
          ./lib/jaxb-runtime-2.3.2.jar \
          ./lib/jakarta.xml.bind-api-2.3.2.jar \
          ./lib/istack-commons-runtime-3.0.8.jar \
          ./lib/jakarta.jws-api-1.1.1.jar \
          ./lib/jakarta.xml.ws-api-2.3.2.jar \
          ./lib/jaxws-rt-2.3.2.jar \
          ./lib/jakarta.xml.soap-api-1.4.1.jar \
          ./lib/jakarta.activation-api-1.2.1.jar \
          ./lib/annotations-api.jar \
          ./lib/streambuffer-1.5.7.jar \
          ./lib/saaj-impl-1.5.1.jar \
          ./lib/policy-2.7.6.jar \
          ./lib/stax-ex-1.8.1.jar \
          ./lib/gmbal-4.0.0.jar \
          ./lib/management-api-3.2.1.jar \
          ./lib/FastInfoset-1.2.16.jar \
          ./lib/pfl-basic-4.0.1.jar \
          ./lib/pfl-tf-4.0.1.jar \
          ./lib/txw2-2.3.2.jar \
          ./lib/commons-cli-*.jar \
          ./lib/commons-io-*.jar \
          ./lib/commons-lang*.jar \
          ./lib/commons-logging-*.jar \
          ./lib/commons-httpclient-3.1.jar \
          ./lib/guava-*.jar \
          ./lib/httpclient-*.jar \
          ./lib/httpcore-*.jar \
          ./lib/metrics-core-*.jar \
          ./lib/metrics-json-*.jar \
          ./lib/metrics-jvm-*.jar \
          ./lib/metrics-servlets-*.jar \
          ./lib/mvel*.jar \
          ./lib/nekohtml-*.jar \
          ./lib/xercesImpl-*.jar \
          ./lib/xml-apis-*.jar \
          ./lib/logback-*.jar \
          ./lib/slf4j-api-1.7.25.jar \
          ./lib/openkit-3.*.jar \
          ./resources/easyTravel.properties \
          ./resources/easyTravelConfig.properties \
          ./resources/easyTravelThirdPartyResourcesizes.properties \
          ./resources/Users.txt \
          ./resources/logback.xml \
          ./com.dynatrace.easytravel.commons.jar \
          ./uemload.jar

mkdir -p "${ET_HLG_DEPLOY_HOME}"
tar -cvzf "${ET_HLG_DEPLOY_HOME}/headlessloadgen.tar.gz" \
          ./lib/jaxb-runtime-2.3.2.jar \
          ./lib/jakarta.xml.bind-api-2.3.2.jar \
          ./lib/istack-commons-runtime-3.0.8.jar \
          ./lib/jakarta.jws-api-1.1.1.jar \
          ./lib/jakarta.xml.ws-api-2.3.2.jar \
          ./lib/jaxws-rt-2.3.2.jar \
          ./lib/jakarta.xml.soap-api-1.4.1.jar \
          ./lib/jakarta.activation-api-1.2.1.jar \
          ./lib/annotations-api.jar \
          ./lib/streambuffer-1.5.7.jar \
          ./lib/saaj-impl-1.5.1.jar \
          ./lib/policy-2.7.6.jar \
          ./lib/stax-ex-1.8.1.jar \
          ./lib/gmbal-4.0.0.jar \
          ./lib/management-api-3.2.1.jar \
          ./lib/FastInfoset-1.2.16.jar \
          ./lib/pfl-basic-4.0.1.jar \
          ./lib/pfl-tf-4.0.1.jar \
          ./lib/txw2-2.3.2.jar \
          ./lib/commons-cli-*.jar \
          ./lib/commons-io-*.jar \
          ./lib/commons-lang*.jar \
          ./lib/commons-logging-*.jar \
          ./lib/commons-httpclient-3.1.jar \
          ./lib/guava-*.jar \
          ./lib/httpclient-*.jar \
          ./lib/httpcore-*.jar \
          ./lib/metrics-core-*.jar \
          ./lib/metrics-json-*.jar \
          ./lib/metrics-jvm-*.jar \
          ./lib/metrics-servlets-*.jar \
          ./lib/mvel*.jar \
          ./lib/nekohtml-*.jar \
          ./lib/xercesImpl-*.jar \
          ./lib/xml-apis-*.jar \
          ./lib/logback-*.jar \
          ./lib/slf4j-api-1.7.25.jar \
          ./lib/openkit-3.*.jar \
          ./lib/jackson-core-2.9.9.jar \
          ./lib/jackson-annotations-2.9.0.jar \
          ./lib/jackson-databind-2.9.9.3.jar \
          ./lib/jackson-jaxrs-base-2.9.9.jar \
          ./lib/jackson-jaxrs-json-provider-2.9.9.jar \
          ./lib/jackson-module-jaxb-annotations-2.9.9.jar \
          ./resources/easyTravel.properties \
          ./resources/easyTravelConfig.properties \
          ./resources/easyTravelThirdPartyResourcesizes.properties \
          ./resources/Users.txt \
          ./resources/logback.xml \
          ./com.dynatrace.easytravel.commons.jar \
          ./uemload.jar \
          ./lib/selenium-server-standalone-3.141.59.jar \
          ./lib/client-combined-3.141.59.jar \
          ./lib/commons-pool-1.6.jar \
          ./lib/littleproxy-1.1.0-beta-bmp-17.jar \
          ./chrome-lin64/** \
          ./lib/netty-all-4.1.56.Final.jar \
          ./lib/commons-codec-1.8.jar \
          ./lib/gson-2.8.0.jar \
          ./lib/tyrus-standalone-client-1.15.jar \
          ./lib/javax.websocket-client-api-1.1.jar \
          ./lib/jna-4.1.0.jar \
          ./lib/json-20080701.jar

mkdir -p "${ET_MGC_DEPLOY_HOME}"
tar -cvzf "${ET_MGC_DEPLOY_HOME}/mongo-db_content-creator-latest.tar.gz" \
          ./lib/jaxb-runtime-2.3.2.jar \
          ./lib/jakarta.xml.bind-api-2.3.2.jar \
          ./lib/istack-commons-runtime-3.0.8.jar \
          ./lib/jakarta.jws-api-1.1.1.jar \
          ./lib/jakarta.xml.ws-api-2.3.2.jar \
          ./lib/jaxws-rt-2.3.2.jar \
          ./lib/jakarta.xml.soap-api-1.4.1.jar \
          ./lib/jakarta.activation-api-1.2.1.jar \
          ./lib/annotations-api.jar \
          ./lib/streambuffer-1.5.7.jar \
          ./lib/saaj-impl-1.5.1.jar \
          ./lib/policy-2.7.6.jar \
          ./lib/stax-ex-1.8.1.jar \
          ./lib/gmbal-4.0.0.jar \
          ./lib/management-api-3.2.1.jar \
          ./lib/FastInfoset-1.2.16.jar \
          ./lib/pfl-basic-4.0.1.jar \
          ./lib/pfl-tf-4.0.1.jar \
          ./lib/txw2-2.3.2.jar \
          ./lib/commons-cli-*.jar \
          ./lib/commons-io-*.jar \
          ./lib/commons-lang*.jar \
          ./lib/commons-logging-*.jar \
          ./lib/commons-httpclient-3.1.jar \
          ./lib/guava-*.jar \
          ./lib/httpclient-*.jar \
          ./lib/httpcore-*.jar \
          ./lib/metrics-core-*.jar \
          ./lib/metrics-json-*.jar \
          ./lib/metrics-jvm-*.jar \
          ./lib/metrics-servlets-*.jar \
          ./lib/mvel*.jar \
          ./lib/nekohtml-*.jar \
          ./lib/xercesImpl-*.jar \
          ./lib/xml-apis-*.jar \
          ./lib/logback-*.jar \
          ./lib/slf4j-api-1.7.25.jar \
          ./lib/mongo-java-driver-3.2.2.jar \
          ./resources/easyTravel.properties \
          ./resources/easyTravelConfig.properties \
          ./resources/Users.txt \
          ./resources/logback.xml \
          ./com.dynatrace.easytravel.commons.jar \
          ./com.dynatrace.easytravel.persistence.common.jar \
          ./com.dynatrace.easytravel.database.jar \
          ./com.dynatrace.easytravel.launcher.jar \
          ./com.dynatrace.easytravel.mongodb.jar
