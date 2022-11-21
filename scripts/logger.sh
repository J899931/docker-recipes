#!/usr/bin/env bash

logfilepath=./test.log

function log() {
	# Output text to stdout and log file.
	printf "[$(date --iso-8601=seconds)] [$0] ${*}\n" >&2
	printf "[$(date --iso-8601=seconds)] [$0] ${*}\n" >> $logfilepath
}

log "[BEGIN  ] Starting."

log "[END    ] Ending."
