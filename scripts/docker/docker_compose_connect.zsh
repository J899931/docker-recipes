#!/usr/bin/env zsh

image=library/usftp
tag=latest
container=usftp
service=sftp
shell=/bin/bash

printf "\033[33mConnecting to <container: ${container}\033[0m\n"
docker exec --interactive --tty $container $shell
