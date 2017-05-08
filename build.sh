#!/usr/bin/env bash
set -v
set -e

# Config
APP_NAME=SimplCommerce

DOCKER_REPO=ba2017
DOCKER_IMAGE=$DOCKER_REPO"/"$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]')
DOCKER_TAG=v0.1-beta

# Build the builder image
docker build --force-rm -t build-image -f Dockerfile.build .
# Create a container from the built image
docker create --name build-container build-image
# Copy binaries
mkdir output
docker cp build-container:/app/src/SimplCommerce.WebHost/publish/ .
#docker cp build-container:/app/src/SimplCommerce.WebHost/Modules/ ./output/Modules/
#docker cp build-container:/app/src/SimplCommerce.WebHost/wwwroot/ ./output/wwwroot/
docker rm build-container

# Build the production image
docker build --force-rm -t $DOCKER_IMAGE -t $DOCKER_IMAGE:$DOCKER_TAG -f Dockerfile.prod .
# cleanup
rm -r publish
# Login to docker hub
#docker login -u="$DOCKER_HUB_USER" -p="$DOCKER_HUB_PASSWORD"
# Push docker image
docker push $DOCKER_IMAGE:$DOCKER_TAG
docker push $DOCKER_IMAGE
