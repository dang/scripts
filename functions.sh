#
# A useful set of bash functions for my scripts
#

die() {
	echo "$@"
	if [ ! -z "$(declare -F | grep "DFGcleanup")" ]; then
		DFGcleanup
	fi
	exit 1
}

usage() {
	local myusage;
	if [ -n "${USAGE}" ]; then
		myusage=${USAGE}
	else
		myusage="No usage given"
	fi
	if [ -n "$1" ]; then
		echo "$@"
	fi
	echo "`basename $0` ${myusage}"
	if [ -n "${LONGUSAGE}" ]; then
		echo -e "${LONGUSAGE}"
	fi
	exit 1
}

#
# Script template:

##!/bin/bash
##
## Script that does something
##
#
## Set usage output
#USAGE="[-hk] [-f <file>] [<directories>]"
#LONGUSAGE="\t-h\tPrint this help message
#\t-k\tKernel database (no system includes)
#\t<directories>\tDirectories to scan (defaults to '.')"
#
## Standard functions
#source ~/bin/scripts/functions.sh
#
## Parse arguments
#while getopts ":hkf:" option; do
#	case ${option} in
#		k ) KERNEL="yes";;
#		f ) FILE=${OPTARG};;
#		h ) usage;;
#		\? ) usage "Invalid argument ${OPTARG}";;
#		* ) usage "Invalid argument ${option}";;
#	esac
#done
#
#if [ "${OPTIND}" != "0" ]; then
#	shift $((OPTIND-1))
#fi
#
# Remaining arguments are in $1, $2, etc. as normal
