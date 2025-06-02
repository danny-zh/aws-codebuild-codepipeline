#!/bin/bash
echo "Pruning the docker image"
sudo docker ps -q | xargs -I sudo docker rm -f {}