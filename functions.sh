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
#source ${HOME}/bin/scripts/functions.sh
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
# Detect which VCS is in use

#
# VCS functions.
# These functions wrap svn/cvs/etc, so that scripts don't have to care

# Set VCS_FATAL_ERRORS if you want errors to be fatal.

# VCS - default to unknown
VCS="unknown"

# Detect the VCS.  Call this first.
function vcs_detect() {
	VCS="unknown"
	if [ -d "${PWD}/.svn" ]; then
		VCS="svn"
	elif [ -d "${PWD}/CVS" ]; then
		VCS="cvs"
	fi

	if [ "${VCS}" == "unknown" ]; then
		if [ -n "${VCS_FATAL_ERRORS}" ]; then
			die "Unknown VCS for ${PWD}"
		else
			echo "Unknown VCS for ${PWD}"
		fi
	fi
}

# Delete something from a VCS
function vcs_rm() {
	if [ "${VCS}" == "svn" ]; then
		svn rm --force $* || die "svn rm failed"
	elif [ "${VCS}" == "cvs" ]; then
		for i in $*; do
			if [ ! -d "${i}" ]; then
				rm ${i} || die "cvs rm failed (rm)"
			fi
		done
		cvs rm $* || die "cvs rm failed (cvs rm)"
	else
		if [ -n "${VCS_FATAL_ERRORS}" ]; then
			die "Unknown VCS for ${PWD}"
		else
			echo "Unknown VCS for ${PWD}"
		fi
	fi
}

# Add something to a VCS
function vcs_add() {
	if [ "${VCS}" == "svn" ]; then
		svn add $* || die "svn add failed"
	elif [ "${VCS}" == "cvs" ]; then
		cvs add $* || die "cvs add failed"
	else
		if [ -n "${VCS_FATAL_ERRORS}" ]; then
			die "Unknown VCS for ${PWD}"
		else
			echo "Unknown VCS for ${PWD}"
		fi
	fi
}

# commit something to a VCS
# ${VCS_COMMITMSG} contains the commit message, ${VCS_COMMITFILE} contains the
# file with the commit message.  Use VCS_REPOMAN_OPTS to pass options to
# repoman.
function vcs_commit() {
	if [ "${VCS}" == "svn" ]; then
		if [ -n "${VCS_COMMITFILE}" ]; then
			svn commit -F "${VCS_COMMITFILE}" $* || die "svn commit failed"
		else
			svn commit -m "${VCS_COMMITMSG}" $* || die "svn commit failed"
		fi
	elif [ "${VCS}" == "cvs" ]; then
		if [ -n "${VCS_COMMITFILE}" ]; then
			repoman ${VCS_REPOMAN_OPTS} --commitmsgfile "${VCS_COMMITFILE}" commit $* || die "cvs comit failed"
		else
			repoman ${VCS_REPOMAN_OPTS} --commitmsg "${VCS_COMMITMSG}" commit $* || die "cvs comit failed"
		fi
	else
		if [ -n "${VCS_FATAL_ERRORS}" ]; then
			die "Unknown VCS for ${PWD}"
		else
			echo "Unknown VCS for ${PWD}"
		fi
	fi
}

# update something in a VCS
function vcs_update() {
	if [ "${VCS}" == "svn" ]; then
		svn up $* || die "svn update failed"
	elif [ "${VCS}" == "cvs" ]; then
		cvs up $* || die "cvs update failed"
	else
		if [ -n "${VCS_FATAL_ERRORS}" ]; then
			die "Unknown VCS for ${PWD}"
		else
			echo "Unknown VCS for ${PWD}"
		fi
	fi
}

# update something in a VCS, checking the results to see if there's conflicts
function vcs_update_check_conflicts() {
	if [ "${VCS}" == "svn" ]; then
		OUTPUT=`svn up $*` || die "svn update failed"
		STATUS=`echo ${OUTPUT} | grep "\<C\>"`
		echo ${OUTPUT}
	elif [ "${VCS}" == "cvs" ]; then
		OUTPUT=`cvs up $*` || die "cvs update failed"
		STATUS=`echo ${OUTPUT} | grep "\<C\>"`
		echo ${OUTPUT}
	else
		if [ -n "${VCS_FATAL_ERRORS}" ]; then
			die "Unknown VCS for ${PWD}"
		else
			echo "Unknown VCS for ${PWD}"
		fi
	fi
	if [ -n "${STATUS}" ]; then
		die "There were conflicts"
	fi
}

# get status on something in a VCS
function vcs_status() {
	if [ "${VCS}" == "svn" ]; then
		svn status $* || die "svn status failed"
	elif [ "${VCS}" == "cvs" ]; then
		cvs -nq up $* || die "cvs status failed"
	else
		if [ -n "${VCS_FATAL_ERRORS}" ]; then
			die "Unknown VCS for ${PWD}"
		else
			echo "Unknown VCS for ${PWD}"
		fi
	fi
}

# diff something in a VCS
function vcs_diff() {
	if [ "${VCS}" == "svn" ]; then
		svn diff $* || die "svn diff failed"
	elif [ "${VCS}" == "cvs" ]; then
		cvs diff $* || die "cvs diff failed"
	else
		if [ -n "${VCS_FATAL_ERRORS}" ]; then
			die "Unknown VCS for ${PWD}"
		else
			echo "Unknown VCS for ${PWD}"
		fi
	fi
}

