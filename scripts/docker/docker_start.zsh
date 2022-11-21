#!/usr/bin/env zsh

project_dir="${HOME}/projects/crondock"
dockerfile="Dockerfile"
dockerfilepath="${project_dir}/${dockerfile}"

repo=""
name="dcron"
tag="latest"
nametag="${name}:${tag}"
container="crondock"

# Check if container is running.
if [[ -n $(docker container ls --filter status=running --filter name=$container --quiet) ]]; then
	printf "[PROCESS] Stopping container: ${container}.\n"
	docker container stop $container
	printf "[REPORT ] Container stopped.\n"
fi

# Check if container is exited and ready for removal.
if [[ $(docker container ls --filter status=exited --filter name=$container --quiet) ]]; then
	printf "[PROCESS] Removing container: ${container}.\n"
	docker container rm $container
	pritnf "[REPORT ] Container removed\n."
fi

printf "[PROCESS] building image <${nametag}>...\n"
if ! docker image build --tag "${nametag}" .; then
	printf "[REPORT ] ERROR on building <${nametag}>.\n"
	# exit 1
else
	printf "[REPORT ] Image built successfully.\n"
fi

printf "[PROCESS] Starting container <${nametag}>...\n"
if ! docker run --detach --hostname $container --interactive --tty --name $container $nametag; then
	printf "[REPORT ] ERROR on running container <${nametag}>.\n"
else
	printf "[REPORT ] Container successfully started.\n"
fi
