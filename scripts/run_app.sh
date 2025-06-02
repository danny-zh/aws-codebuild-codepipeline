#!/bin/bash
echo "Running the docker image"
sudo docker run --name httpd_alpine -d -p 80:80 $IMAGE_REPO_NAME:$IMAGE_TAG
