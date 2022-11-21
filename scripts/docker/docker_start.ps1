#!/usr/bin/env pwsh

$Script:ErrorActionPreference = [System.Management.Automation.ActionPreference]::Continue

[String]$project_dir = "${HOME}/projects/docker-recipes"
[String]$dockerfile = "Dockerfile"
[String]$dockerfilepath = "${project_dir}\${dockerfile}"

[String]$name = "basic"
[String]$tag = "latest"
[String]$nametag = "${name}:${tag}"
[String]$container = "basic_box"

# Check if container is running.
if ($(docker container ls --filter status=running --filter name=$container --format='true')) {
	Write-Host "[PROCESS] Stopping container: ${container}."
	docker container stop $container
	Write-Host "[REPORT ] Container stopped."
}

# Check if container is exited and ready for removal.
if ($(docker container ls --filter status=exited --filter name=$container --format='true')) {
	Write-Host "[PROCESS] Removing container: ${container}."
	docker container rm $container
	Write-Host "[REPORT ] Container removed."
}

Write-Host "[PROCESS] building image <${nametag}>..."
docker image build --tag "${nametag}" .
if (-not $?) {
	Write-Error "[REPORT ] Failed to build image, exit code: ${lastExitCode}, aborting" -ErrorAction Stop
}
else {
	Write-Host "[REPORT ] Image built successfully."
}

Write-Host "[PROCESS] Starting container <${nametag}>..."
docker run --detach --hostname $container --interactive --tty --name $container $nametag
if (-not $?) {
	Write-Error "[REPORT ] Failed to start container, exit code: ${lastExitCode}, aborting" -ErrorAction Stop
}
else {
	Write-Host "[REPORT ] Container successfully started."
}
