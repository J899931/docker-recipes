#!/usr/bin/env zsh

project_dir="${HOME}/projects/docker-recipes"
dockerfile="Dockerfile"
dockerfilepath="${project_dir}/${dockerfile}"

name="deb_basic"
tag="latest"
nametag="${name}:${tag}"
container="basic_box"

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
