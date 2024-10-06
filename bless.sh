# SPDX-License-Identifier: AGPL-3.0-or-later
# Copyright (C) 2024  Jakob Kalus

# fake horizontal scrolling for unix shells
bless() {
	# give some help
	if [ "$#" -eq 0 ]; then
		echo "usage: bless [command] [command-arguments ...]"
		return
	fi
	
	# filter out non-existent commands
	command -v "$1"	> /dev/null 2>&1
	
	if [ "$?" -ne 0 ]; then
		echo "bless: could not execute \"$1\"."
		echo "It doesn't appear to exist."
		return
	fi
	
	# filter out shell functions
	_COMMAND_TYPE="$(command -V "$1")"
	_COMMAND_TYPE="$(echo "$_COMMAND_TYPE" | head -1)"
	_COMMAND_TYPE="$(echo "$_COMMAND_TYPE" | sed 's/^.* \(function\)$/\1/')"
	
	if [ "$_COMMAND_TYPE" = "function" ]; then
		echo "bless: could not execute \"$1\"."
		echo "\"unbuffer\" doesn't like shell functions."
		return
	fi
	
	# create output redirection target
	_TEMP_FILE="$(mktemp)"
	
	# open less in the background
	less +F -NRS -# 4 "$_TEMP_FILE" &
	_LESS_PID="$!"
	
	# run command
	{
		unbuffer "${@}" > "$_TEMP_FILE" 2>&1
		
		# give less some time to grab everything
		sleep 1
		
		# only tell less to stop listening, if we're reasonably sure that it's our less process
		_LESS_PID_TEST="$(ps aux)"
		_LESS_PID_TEST="$(echo "$_LESS_PID_TEST" | grep "less +F -NRS -# 4 $_TEMP_FILE")"
		_LESS_PID_TEST="$(echo "$_LESS_PID_TEST" | grep -v "grep")"
		_LESS_PID_TEST="$(echo "$_LESS_PID_TEST" | sed 's/[^0-9]*\([0-9]*\).*/\1/')"
		
		if [ "$_LESS_PID" = "$_LESS_PID_TEST" ];
		then
			# tell less to stop listening
			kill -INT "$_LESS_PID"
		fi
	} &
	
	# bring less to the foreground
	fg %1 > /dev/null 2>&1
	
	# wait until command is done and less is closed
	wait > /dev/null 2>&1
	
	# don't lose the command output
	cat "$_TEMP_FILE"
	
	# cleanup
	rm "$_TEMP_FILE"
	
	#echo "$_TEMP_FILE"
}
