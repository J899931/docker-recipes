#!/usr/bin/env pwsh

[String]$project_dir = "${HOME}/projects/docker-recipes"
[String]$dockerfile = "Dockerfile"
[String]$dockerfilepath = "${project_dir}\${dockerfile}"

[String]$name = "deb_basic"
[String]$tag = "latest"
[String]$nametag = "${name}:${tag}"
[String]$container = "basic_box"

# Check if container is running then stop it.
if ($(docker container ls --filter status=stopped --filter name=$container --format='true')) {
	Write-Host "[PROCESS] Starting container: ${container}..."
	docker container start $container
	Write-Host "[REPORT ] Container started."
}

if ($(docker container ls --all --filter name="${container}" --format='true')) {
	Write-Host "[PROCESS] Connecting to container..."
	docker exec --interactive --tty  $container /bin/bash
	Write-Host "[REPORT ] Connected to container."
}
else {
	Write-Host "[REPORT ] Container does not exists."
}
