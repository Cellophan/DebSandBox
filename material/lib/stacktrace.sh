#!/bin/bash

function stacktrace() {
	local err=$?
	set +o xtrace
	local code="${1:-1}"
	echo "Error in ${BASH_SOURCE[1]}:${BASH_LINENO[0]}. '${BASH_COMMAND}' exited with status $err"
	# Print out the stack trace described by $function_stack
	if [ ${#FUNCNAME[@]} -gt 2 ]; then
		echo "Call tree:"
		for ((i=1;i<${#FUNCNAME[@]}-1;i++)); do
			echo " $i: ${BASH_SOURCE[$i+1]}:${BASH_LINENO[$i]} ${FUNCNAME[$i]}(...)"
		done
	fi
	echo "Exiting with status ${code}"
	exit "${code}"
}

# trap ERR to provide an error handler whenever a command exits nonzero
#  this is a more verbose version of set -o errexit
trap 'stacktrace' ERR
# setting errtrace allows our ERR trap handler to be propagated to functions,
#  expansions and subshells
set -o errtrace
set -Eeuo pipefail


