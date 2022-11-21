#!/usr/bin/env pwsh

[String]$project_dir = "${HOME}/projects/docker-recipes"
[String]$dockerfile = "Dockerfile"
[String]$dockerfilepath = "${project_dir}\${dockerfile}"

[String]$name = "basic"
[String]$tag = "latest"
[String]$nametag = "${name}:${tag}"
[String]$container = "basic_box"


# Check if container is running then stop it.
if ($(docker container ls --filter status=running --filter name=$container --format='true')) {
	Write-Host "[PROCESS] Stopping container: ${container}."
	docker container stop $container
	Write-Host "[REPORT ] Container stopped."
}

# Check if container is exited then remove it.
if ($(docker container ls --filter status=exited --filter name=$container --format='true')) {
	Write-Host "[PROCESS] Removing container: ${container}."
	docker container rm $container
	Write-Host "[REPORT ] Container removed."
}
