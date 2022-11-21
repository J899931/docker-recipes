#!/usr/bin/env zsh

repo=""
name="dcron"
tag="latest"
nametag="${name}:${tag}"
container="crondock"

# Check if container is running then stop it.
if [[ $(docker container ls --filter status=running --filter name=$container --format='true') ]]; then
	printf "[PROCESS] Stopping container: ${container}.\n"
	docker container stop $container
	printf "[REPORT ] Container stopped.\n"
fi

# Check if container is exited then remove it.
if [[ $(docker container ls --filter status=exited --filter name=$container --format='true') ]]; then
	printf "[PROCESS] Removing container: ${container}.\n"
	docker container rm $container
	printf "[REPORT ] Container removed\n."
fi
