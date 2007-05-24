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
	echo ""
	echo "Usage:"
	echo "`basename $0` ${myusage}"
	if [ -n "${LONGUSAGE}" ]; then
		echo -e "${LONGUSAGE}"
	fi
	exit 1
}

#
# Script templates:

#
# Long options, using getopt(1)

##!/bin/bash
##
## Script that does something
##
#
## Set usage output
#USAGE="[-h |--help] [-k | --kernel] [-f <file> | --file=<file>] [<directories>]"
#LONGUSAGE="\t-h, --help\n\t\tPrint this help message
#\t-k, --kernel\n\t\tKernel database (no system includes)
#\t-f <file>, --file=<file>\n\t\tstore output into <file>
#\t<directories>\n\t\tDirectories to scan (defaults to '.')"
#
## Standard functions
#source ${HOME}/bin/scripts/functions.sh
#
## Script name
#ME=$(basename $0)
#
## Parse arguments
#ARGS=`getopt -o hkf: --long help,kernel,file: -n "${ME}" -- "$@"`
#
#if [ $? != 0 ] ; then
#	usage 
#fi
#eval set -- "$ARGS"
#
#while true ; do
#	case "$1" in
#		-h|--help) usage; shift ;;
#		-k|--kernel) KERNEL="yes"; shift ;;
#		-f|--file) FILE=$2 ; shift 2 ;;
#		--) shift ; break ;;
#		* ) usage "Invalid argument $1";;
#	esac
#done
#
# Remaining arguments are in $1, $2, etc. as normal


#
# Short args using getopts

##!/bin/bash
##
## Script that does something
##
#
## Set usage output
#USAGE="[-hk] [-f <file>] [<directories>]"
#LONGUSAGE="\t-h\tPrint this help message
#\t-k\tKernel database (no system includes)
#\t-f <file>\store output into <file>
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

# Do a changelog
function vcs_echangelog() { 
	if [ "${VCS}" == "cvs" ]; then
		VCS_ECHANGELOG=echangelog
	else
		VCS_ECHANGELOG=echangelog-tng
	fi

	if [ -n "${VCS_COMMITFILE}" ]; then
		ECHANGELOG_EDITOR= ${VCS_ECHANGELOG} < ${VCS_COMMITFILE} || die "${VCS_ECHANGELOG} failed"
	elif [ -n "${VCS_COMMITMSG}" ]; then
		${VCS_ECHANGELOG} "${VCS_COMMITMSG}" || die "${VCS_ECHANGELOG} died"
	fi
}

# See if a file is under version control
function vcs_is_added() {
	if [ "${VCS}" == "svn" ]; then
		OUTPUT=$(svn info $@ | grep Path:)
	elif [ "${VCS}" == "cvs" ]; then
		OUTPUT=$(cvs status $@ 2>/dev/null | grep Status | grep -v Unknown)
	else
		if [ -n "${VCS_FATAL_ERRORS}" ]; then
			die "Unknown VCS for ${PWD}"
		else
			echo "Unknown VCS for ${PWD}"
		fi
	fi
	if [ -z "${OUTPUT}" ]; then
		return 1
	fi
	return 0
}
