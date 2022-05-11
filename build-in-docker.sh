DOCKER_CONTAINER_BUILD_SH_PREFIX=${DOCKER_CONTAINER_BUILD_SH_PREFIX:-.}
DOCKER_CONTAINER_WORKDIR=/workspace

if [ ! -z "${ET_DEPLOY_HOME}" ]; then
    # Make sure that ET_DEPLOY_HOME gets a location inside the user's current working
    # directory, which gets mounted into as the Docker container's DOCKER_CONTAINER_WORKDIR.
    ET_DEPLOY_HOME="${DOCKER_CONTAINER_WORKDIR}/${ET_DEPLOY_HOME}"
else
    ET_DEPLOY_HOME="${DOCKER_CONTAINER_WORKDIR}/deploy"
fi

docker run --rm \
--volume "$(pwd):${DOCKER_CONTAINER_WORKDIR}" \
--env ET_SRC_URL="${ET_SRC_URL}" \
--env ET_DEPLOY_HOME="${ET_DEPLOY_HOME}" \
--env ET_BB_DEPLOY_HOME="${ET_BB_DEPLOY_HOME}" \
--env ET_CF_DEPLOY_HOME="${ET_CF_DEPLOY_HOME}" \
--env ET_ACF_DEPLOY_HOME="${ET_ACF_DEPLOY_HOME}" \
--env ET_LG_DEPLOY_HOME="${ET_LG_DEPLOY_HOME}" \
--env ET_HLG_DEPLOY_HOME="${ET_HLG_DEPLOY_HOME}" \
--env ET_MG_DEPLOY_HOME="${ET_MG_DEPLOY_HOME}" \
--env ET_MGC_DEPLOY_HOME="${ET_MGC_DEPLOY_HOME}" \
--env ET_PS_DEPLOY_HOME="${ET_PS_DEPLOY_HOME}" \
--user "$(id -u):$(id -g)" \
perrit/apache-ant \
"${DOCKER_CONTAINER_WORKDIR}/${DOCKER_CONTAINER_BUILD_SH_PREFIX}/build-et.sh"
