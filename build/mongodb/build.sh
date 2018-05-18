#!/bin/bash
export DOCKER_IMAGE_NAME=dynatrace/easytravel-mongodb
export DOCKER_IMAGE_VERSION=7.1

../../scripts/docker-build-image.sh
