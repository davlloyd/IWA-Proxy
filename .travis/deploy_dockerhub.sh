#!/bin/sh
docker login -e $DOCKER_EMAIL -u $DOCKER_ACCOUNT -p $DOCKER_PASSWORD
if [ "$TRAVIS_BRANCH" = "master" ]; then
    TAG="latest"
else
    TAG="$TRAVIS_BRANCH"
fi
docker push $IMAGE_NAME:latest

