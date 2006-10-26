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

# VCS - default to unknown
VCS="unknown"

# Detect the VCS.  Call this first.
function vcs_detect() {
	if [ -d "${PORTDIR}/.svn" ]; then
		VCS="svn"
	elif [ -d "${PORTDIR}/CVS" ]; then
		VCS="cvs"
	fi

	if [ "${VCS}" == "unknown" ]; then
		die "Unknwon VCS for ${PORTDIR}"
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
		die "Unknown VCS ${VCS}"
	fi
}

# Add something to a VCS
function vcs_add() {
	if [ "${VCS}" == "svn" ]; then
		svn add $* || die "svn add failed"
	elif [ "${VCS}" == "cvs" ]; then
		cvs add $* || die "cvs add failed"
	else
		die "Unknown VCS ${VCS}"
	fi
}

# commit something to a VCS
function vcs_commit() {
	if [ "${VCS}" == "svn" ]; then
		svn commit -m "$*" || die "svn commit failed"
	elif [ "${VCS}" == "cvs" ]; then
		repoman --commitmsg "$*" commit || die "cvs add failed"
	else
		die "Unknown VCS ${VCS}"
	fi
}

# update something in a VCS
function vcs_update() {
	if [ "${VCS}" == "svn" ]; then
		svn up $* || die "svn commit failed"
	elif [ "${VCS}" == "cvs" ]; then
		cvs up $* || die "cvs add failed"
	else
		die "Unknown VCS ${VCS}"
	fi
}

#
# Portage related functions

#
# cd to a package location by name in a portdir
function gecd() {
	cd ${PORTDIR}/`PORTDIR=${PORTDIR} herdstat -f $*` || die "gecd failed"
}

