#!/bin/bash
DOCKER_FILE=${DOCKER_FILE:-Dockerfile}
DOCKER_IMAGE_NAME=${DOCKER_IMAGE_NAME}
DOCKER_IMAGE_VERSION=${DOCKER_IMAGE_VERSION}

if [ -z "${DOCKER_IMAGE_NAME}" ]; then
  echo "Error: DOCKER_IMAGE_NAME is undefined"; exit 1
fi

if [ -z "${DOCKER_IMAGE_VERSION}" ]; then
  echo "Error: DOCKER_IMAGE_VERSION is undefined"; exit 1
fi

echo "Building Docker image: ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}"
docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION} -f ${DOCKER_FILE} .
if [ $? -ne 0 ]; then
  echo "Error: could not build image: ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION}"; exit 1
fi 

docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION} ${DOCKER_IMAGE_NAME}