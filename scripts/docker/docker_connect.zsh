#!/usr/bin/env zsh

repo=""
name="dcron"
tag="latest"
nametag="${name}:${tag}"
container="crondock"

# Check if container is running then stop it.
if [[ $(docker container ls --filter status=stopped --filter name=$container --format='true') ]]; then
	printf "[PROCESS] Starting container: ${container}.\n"
	docker container start $container
	printf "[REPORT ] Container started.\n"
fi

if [[ $(docker container ls --all --filter name="${container}" --format='true') ]]; then
	printf "[PROCESS] Connecting to container.\n"
	docker exec --interactive --tty  $container /bin/bash
	printf "[REPORT ] Connected to container.\n"
else
	printf "[REPORT ] Container does not exists.\n"
fi
