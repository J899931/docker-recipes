#!/usr/bin/env zsh

project_dir="${HOME}/projects/docker-recipes"
dockerfile="Dockerfile"
dockerfilepath="${project_dir}/${dockerfile}"

name="deb_basic"
tag="latest"
nametag="${name}:${tag}"
container="basic_box"

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
