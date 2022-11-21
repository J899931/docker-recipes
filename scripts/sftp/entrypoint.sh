#!/usr/bin/env bash
set -e

[ "${DEBUG}" == 'true' ] && set -x

logfilepath=./entrypoint.log

function log() {
	# Output text to stdout.
	echo "[$0] $*" >&2
}

log "\033[0;44m---> Starting the sftp server.\033[0m\n"

# Source custom scripts.
# Any scripts will execute when the session starts.
if [ -d /etc/sftp.d ]; then
	for f in /etc/sftp.d/*; do
		if [ -x "$f" ]; then
			log "Running $f ..."
			$f
		else
			log "Could not run $f, because it's missing execute permission (+x)."
		fi
	done
	unset f
fi

# Use `exec` to preventing starting a sub-shell process.
# -D: When this option is specified, sshd will not detach and does not become a daemon. This allows easy monitoring of sshd.
# -e: Output errors to stdout instead of syslog
log "Executing sshd..."
exec /usr/sbin/sshd -D -e

# exec "$@"
