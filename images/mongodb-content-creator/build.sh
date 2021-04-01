#!/bin/bash
export DOCKER_IMAGE_NAME=dynatrace/easytravel-mongodb-content-creator
export DOCKER_IMAGE_VERSION=latest

../../scripts/docker-build-image.sh
