#!/bin/bash

IMAGE_NAME="emacs"
CONTAINER_NAME="emacs_deb"

echo "Starting build"

# Segmentation fault fix
# https://github.com/moby/moby/issues/22801
sudo su -c 'echo 0 > /proc/sys/kernel/randomize_va_space'
docker build --no-cache -t $IMAGE_NAME .
sudo su -c 'echo 2 > /proc/sys/kernel/randomize_va_space'

echo "Starting container"
docker run -d --name $CONTAINER_NAME $IMAGE_NAME

echo "Copying packages"
docker cp $CONTAINER_NAME:/build/ .
cp -r build/*.deb .
rm -r build/

echo "Stopping and removing container"
docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME
