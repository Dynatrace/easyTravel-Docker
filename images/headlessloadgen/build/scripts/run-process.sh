#!/bin/bash
ET_ANGULAR_FRONTEND_URL=${ET_ANGULAR_FRONTEND_URL:-'http://localhost:9079'}
ET_PROBLEMS_DELAY=${ET_PROBLEMS_DELAY:-0}
ET_VISIT_NUMBER=${ET_VISIT_NUMBER:-3}
EXTRA_OPTS="--installationMode ${ET_APM_SERVER_DEFAULT:-APM}"
SCENARIO="${SCENARIO_NAME:-Headless Angular Scenario}"
ET_PROBLEMS_DELAY=${ET_PROBLEMS_DELAY:-0}
MAX_CHROME_DRIVERS=${MAX_CHROME_DRIVERS:-1}

if [ -n "${ET_BACKEND_URL}" ]; then
  echo "Waiting for the easyTravel Business Backend on ${ET_BACKEND_URL}"
  wait-for-cmd.sh "nc -z `echo ${ET_BACKEND_URL} | sed 's/http:\/\///' | sed 's/:/ /'`" 360
  (sleep ${ET_PROBLEMS_DELAY} && run-problem-patterns.sh) &
fi

echo "Waiting for the easyTravel Customer Frontend on ${ET_ANGULAR_FRONTEND_URL}"
wait-for-cmd.sh "nc -z `echo ${ET_ANGULAR_FRONTEND_URL} | sed 's/https\?:\/\///' | sed 's/:/ /'`" 360
java ${JAVA_OPTS} -Dconfig.chromeDriverOpts=no-sandbox,disable-dev-shm-usage -Dconfig.maximumChromeDrivers=${MAX_CHROME_DRIVERS} -Dconfig.maximumChromeDriversMobile=${MAX_CHROME_DRIVERS} -jar uemload.jar --autorun true --const ${ET_VISIT_NUMBER} --server ${ET_ANGULAR_FRONTEND_URL} ${EXTRA_OPTS} --scenario "${SCENARIO}"
