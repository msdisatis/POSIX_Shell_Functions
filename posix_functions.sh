#!/bin/bash
# This script is meant to be sourced. Check the tail of the file to see how you
# should source it.

# This function assumes that the binary files are built in the 'bin' sub
# directory and the configuration files are in the 'configuration' sub
# directory.
#$1 = submoduleDirectory
#$2 = binaryDestinationDir
function buildSubmoduleAndCopyBinariesToTheDestinationIfItExists() {
	local SUBMODULE_DIR="${SCRIPT_DIR}/$1"
	if [[ -d ${SUBMODULE_DIR} ]]; then
		echo "Changing directory to \"${SUBMODULE_DIR}\""
		cd "${SUBMODULE_DIR}" || exit 1
		pwd
		make build
		cp --recursive --verbose bin/ "$2"
		cp --recursive --verbose configuration/ "$2"
		cd "${SCRIPT_DIR}" || exit 1
		pwd
	else
		echo "Error: Submodule \"$1\" does not exists."
		exit 1
	fi
}

#$1 = srcDir
#$2 = dst
function copyIfSourceDirectoryExists() {
	if [[ -d $1 ]]; then
		echo "Copying \"$1\" to \"$2\""
		cp --recursive --verbose "$1" "$2"
	else
		echo "Error: Copying \"$1\" to \"$2\" failed."
		exit 1
	fi
}

#$1 = srcFile
#$2 = dst
function copyIfSourceFileExists() {
	if [[ -f $1 ]]; then
		echo "Copying \"$1\" to \"$2\""
		cp --verbose "$1" "$2"
	else
		echo "Error: Copying \"$1\" to \"$2\" failed."
		exit 1
	fi
}

#$1 = string
#$2 = filePath
function doesFileIncludeAString() {
	if [[ ! -f $2 ]]; then
		return 1 # false
	fi
	local STRING
	STRING=$(grep "$1" "$2")
	if [[ -z ${STRING} ]]; then
		return 1 # false
	fi
	return 0 # true
}

#$1 = file
#$2 = setDownloadedFileAsExecutable
#$3 = downloadURL
function downloadFileIfDoesNotExist() {
	if [[ -f $1 ]]; then
		echo "File already exists. Skipping download \"$1\"."
	else
		wget --output-document="$1" "$3"
		if $2; then
			chmod +x --verbose "$1"
		fi
	fi
}

#$1 = file path
#$2 = strip NUMBER leading components from file names on extraction
#$3 = destination directory
function extractFileIfExists() {
	if [[ -f $1 ]]; then
		echo "Extracting \"$1\" to \"$3\""
		tar --directory="$3" --extract --file="$1" --strip-components="$2" \
			--verbose
	else
		echo "Error: Extracting \"$1\" to \"$3\" failed."
	fi
}

# Print a trace of simple commands, 'for' commands, 'case' commands, 'select'
# commands, and 'arithmetic for' commands and their arguments or associated word
# lists after they are expanded and before they are executed.
#set -x

# Sourcing how to:

## FOLLOWING METHOD SETS TWO GLOBAL VARIABLES:
## START_DIR
## SCRIPT_DIR
#function setStartDirectoryAndScriptDirectory() {
#	# THESE TWO VARIABLES ARE GLOBAL
#	START_DIR=$(pwd)
#	SCRIPT_DIR=$(realpath "$(dirname "${BASH_SOURCE[0]}")")
#	echo "Start directory: ${START_DIR}"
#	echo "Script directory: ${SCRIPT_DIR}"
#	echo "Script directory contents:"
#	ls --almost-all -c --classify --group-directories-first --human-readable \
#		--inode -l "${SCRIPT_DIR}"
#}
#setStartDirectoryAndScriptDirectory
#. "${SCRIPT_DIR}/POSIX_Shell_Functions/posix_functions.sh"
