#!/usr/bin/env zsh

image=archry
tag=latest
container=os_arch
service=testr
#dir_logs=./volumes/test_logs
dc_file=docker-compose.yml

image=library
tag=latest
container=usftp
service=sftp

printf "[REPORT ] Checking for running <service: ${service}>\n"
# Stop service containers gracefully, if service is in the running state.
# if docker-compose ps --services --filter status=running | grep -q "${service}"; then
# 	# Report if service was found.
# 	printf "[REPORT ] Found running <service: ${service}>\n"
#
# 	# Stop running service.
# 	printf "[PROCESS] Stopping & removing <service: ${service}>\n"
# 	docker-compose stop ${service}
# 	docker-compose down
# fi

# Build the images for the service's containers.
printf "[PROCESS] Building images for <service: ${service}>\n"
# docker-compose build ${service} --no-cache

# Start the service's containers, in a background process.
printf "[PROCESS] Starting <service: ${service}>\n"
docker-compose up --detach $service --force-recreate

printf "[REPORT ] Checking for running <service: ${service}>\n"

# Stop service containers gracefully, if service is in the running state.
if docker-compose -f ${dc_file} ps --services --filter status=running | grep -q "${service}"; then
	# Report if service was found.
	printf "[REPORT ] Found running <service: ${service}>\n"

	# Stop running service.
	printf "[PROCESS] Stopping & removing <service: ${service}>\n"

	docker-compose -f ${dc_file} stop "${service}"

	sleep 3

	docker-compose -f ${dc_file} down "${service}"
	printf "[REPORT ] <service: ${service}> stopped\n"
fi

# Build the image.
printf "[PROCESS] Building <service: ${service}> ...\n"
docker-compose -f ${dc_file} build ${service}
printf "[REPORT ] <service: ${service}> built\n"

# Run the container in a background process.
printf "[PROCESS] Starting <service: ${service}>\n"
docker-compose -f ${dc_file} up --detach ${service}
printf "[REPORT ] <service: ${service}> started\n"
