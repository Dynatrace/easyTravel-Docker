#!/bin/bash
export DOCKER_IMAGE_NAME=dynatrace/easytravel-loadgen
export DOCKER_IMAGE_VERSION=latest

../../scripts/docker-build-image.sh
