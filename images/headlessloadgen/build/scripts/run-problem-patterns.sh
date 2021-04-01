#!/bin/bash
ET_PROBLEMS=${ET_PROBLEMS:-'BadCacheSynchronization,CPULoad,DatabaseCleanup,DatabaseSlowdown,FetchSizeTooSmall,JourneySearchError404,JourneySearchError500,LoginProblems,MobileErrors,TravellersOptionBox'}
ET_PROBLEM_CHANGE_INTERVAL_S=${1:-$((10 * 60))}
ET_PROBLEM_UPDATE_INTERVAL_S=${2:-5}

ET_BACKEND_CONFIG_SERVICE="${ET_BACKEND_URL}/services/ConfigurationService"

if [ -z "${ET_BACKEND_URL}" ]; then
  echo "Info: ET_BACKEND_URL is not defined, no problem patterns will be applied"
  exit 0
fi

if [ ${ET_PROBLEM_UPDATE_INTERVAL_S} -gt ${ET_PROBLEM_CHANGE_INTERVAL_S} ]; then
  echo "Error: ${ET_PROBLEM_UPDATE_INTERVAL_S} must be <= ${ET_PROBLEM_CHANGE_INTERVAL_S}"
  exit 1
fi

enableProblem() {
  local PROBLEM="$1"

  if [ -n "${PROBLEM}" ]; then
    echo "Enabling easyTravel problem: ${PROBLEM}"
    wget -qO- "${ET_BACKEND_CONFIG_SERVICE}/registerPlugins?pluginData=${PROBLEM}"
    wget -qO- "${ET_BACKEND_CONFIG_SERVICE}/setPluginEnabled?name=${PROBLEM}&enabled=true"
  fi
}

disableProblem() {
  local PROBLEM="$1"

  if [ -n "${PROBLEM}" ]; then
    echo "Disabling easyTravel problem: ${PROBLEM}"
    wget -qO- "${ET_BACKEND_CONFIG_SERVICE}/setPluginEnabled?name=${PROBLEM}&enabled=false"
  fi
}

# Read the list (csv) of easyTravel Problems into an array
IFS=, read -r -a ET_PROBLEMS <<< "${ET_PROBLEMS}"

# Set the state of the algorithm.
LAST_ET_PROBLEM=
CURRENT_ET_PROBLEM="${ET_PROBLEMS[0]}"
NUM_ET_PROBLEMS=${#ET_PROBLEMS[@]}

# Continually disable previous and enable next easyTravel problems every ET_PROBLEM_UPDATE_INTERVAL_S seconds.
# Repeatedly updating the same state at the server is a best-effort approach in clustered environments where
# services are replicated and the number of service instances is unknown.
let i=0
let t=0
while true; do
  # Disable the previously enabled problem iff NUM_ET_PROBLEMS > 1, as otherwise, if NUM_ET_PROBLEMS == 1,
  # the selected problem would continually be disabled and enabled, possibly leading to jittery behavior.
  if [ ${NUM_ET_PROBLEMS} -gt 1 ]; then
    disableProblem "${LAST_ET_PROBLEM}"
  fi

  enableProblem "${CURRENT_ET_PROBLEM}"

  # Check if ET_PROBLEM_CHANGE_INTERVAL_S seconds have exceeded since the problem has changed last.
  if [ $((t * ET_PROBLEM_UPDATE_INTERVAL_S)) -ge ${ET_PROBLEM_CHANGE_INTERVAL_S} ]; then
    # Advance the index into ET_PROBLEMS (mod NUM_ET_PROBLEMS) to point to the next problem.
    let i=$(((i + 1) % NUM_ET_PROBLEMS))
    let t=0

    # Remember the currently enabled problem and set the stage for the next problem.
    LAST_ET_PROBLEM="${CURRENT_ET_PROBLEM}"
    CURRENT_ET_PROBLEM="${ET_PROBLEMS[$i]}"
  fi

  # Iterate every ET_PROBLEM_UPDATE_INTERVAL_S seconds.
  sleep ${ET_PROBLEM_UPDATE_INTERVAL_S}
  let t=$((t + 1))
done
