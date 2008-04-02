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
#source ${HOME}/.scripts/functions.sh
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
#source ${HOME}/.scripts/functions.sh
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
# Set VCS_FAKE if you want file operations without actual VCS operations

# VCS - default to unknown
VCS="unknown"

# Detect the VCS.  Call this first.
function vcs_detect() {
	VCS="unknown"
	if [ -d "${PWD}/.svn" ]; then
		VCS="svn"
	elif [ -n "$(git rev-parse --git-dir)" ]; then
		VCS="git"
	elif [ -d "${PWD}/CVS" ]; then
		VCS="cvs"
	fi

	if [ -n "${VCS_FAKE}" ]; then
		VCS="fake"
	fi

	if [ "${VCS}" == "unknown" ]; then
		if [ -n "${VCS_FATAL_ERRORS}" ]; then
			die "Unknown VCS for ${PWD}"
		else
			echo "Unknown VCS for ${PWD}"
			VCS="fake"
		fi
	fi
}

# Internal setup, called at the beginning of each function.  Sets up local variables.
function vcs_int_setup() {
	case "${VCS}" in
		svn)
			if [ -n "${VCS_FORCE}" ]; then
				VCS_INT_FORCE="--force"
			else
				VCS_INT_FORCE=""
			fi
			;;
		git)
			if [ -n "${VCS_FORCE}" ]; then
				VCS_INT_FORCE="-f"
			else
				VCS_INT_FORCE=""
			fi
			;;
		cvs)
			if [ -n "${VCS_FORCE}" ]; then
				VCS_INT_FORCE="-f"
			else
				VCS_INT_FORCE=""
			fi
			;;
		fake)
			VCS_INT_FORCE=""
			;;
		*)
			if [ -n "${VCS_FATAL_ERRORS}" ]; then
				die "Unknown VCS for ${PWD}"
			else
				echo "Unknown VCS for ${PWD}"
			fi
			;;
	esac
}

# Delete something from a VCS
function vcs_rm() {
	vcs_int_setup
	case "${VCS}" in
		svn)
			svn rm ${VCS_INT_FORCE} $* || die "svn rm failed"
			;;
		git)
			git rm ${VCS_INT_FORCE} $* || die "git rm failed"
			;;
		cvs)
			for i in $*; do
				if [ ! -d "${i}" ]; then
					rm ${i} || die "cvs rm failed (rm)"
				fi
			done
			cvs rm $* || die "cvs rm failed (cvs rm)"
			;;
		fake)
			for i in $*; do
				if [ ! -d "${i}" ]; then
					rm ${i} || die "rm $i failed"
				fi
			done
			for i in $*; do
				if [ -d "${i}" ]; then
					rmdir ${i} || die "rmdir $i failed"
				fi
			done
			;;
		*)
			if [ -n "${VCS_FATAL_ERRORS}" ]; then
				die "Unknown VCS for ${PWD}"
			else
				echo "Unknown VCS for ${PWD}"
			fi
			;;
	esac
}

# Add something to a VCS
function vcs_add() {
	vcs_int_setup
	case "${VCS}" in
		svn)
			svn add $* || die "svn add failed"
			;;
		git)
			git add $* || die "git add failed"
			;;
		cvs)
			cvs add $* || die "cvs add failed"
			;;
		fake)
			;;
		*)
			if [ -n "${VCS_FATAL_ERRORS}" ]; then
				die "Unknown VCS for ${PWD}"
			else
				echo "Unknown VCS for ${PWD}"
			fi
			;;
	esac
}

# commit something to a VCS
# ${VCS_COMMITMSG} contains the commit message, ${VCS_COMMITFILE} contains the
# file with the commit message.  Use VCS_REPOMAN_OPTS to pass options to
# repoman.
function vcs_commit() {
	vcs_int_setup
	case "${VCS}" in
		svn)
			if [ -n "${VCS_COMMITFILE}" ]; then
				svn commit -F "${VCS_COMMITFILE}" $* || die "svn commit failed"
			else
				svn commit -m "${VCS_COMMITMSG}" $* || die "svn commit failed"
			fi
			;;
		git)
			if [ -n "${VCS_COMMITFILE}" ]; then
				git commit -a -F "${VCS_COMMITFILE}" $* || die "git commit failed"
			else
				git commit -a -m "${VCS_COMMITMSG}" $* || die "git commit failed"
			fi
			git push || die "git push failed"
			;;
		cvs)
			if [ -n "${VCS_COMMITFILE}" ]; then
				repoman ${VCS_REPOMAN_OPTS} --commitmsgfile "${VCS_COMMITFILE}" commit $* || die "cvs comit failed"
			else
				repoman ${VCS_REPOMAN_OPTS} --commitmsg "${VCS_COMMITMSG}" commit $* || die "cvs comit failed"
			fi
			;;
		fake)
			;;
		*)
			if [ -n "${VCS_FATAL_ERRORS}" ]; then
				die "Unknown VCS for ${PWD}"
			else
				echo "Unknown VCS for ${PWD}"
			fi
			;;
	esac
}

# update something in a VCS
function vcs_update() {
	vcs_int_setup
	case "${VCS}" in
		svn)
			svn up $* || die "svn update failed"
			;;
		git)
			git pull $* || die "git pull failed"
			;;
		cvs)
			cvs up $* || die "cvs update failed"
			;;
		fake)
			;;
		*)
			if [ -n "${VCS_FATAL_ERRORS}" ]; then
				die "Unknown VCS for ${PWD}"
			else
				echo "Unknown VCS for ${PWD}"
			fi
			;;
	esac
}

# update something in a VCS, checking the results to see if there's conflicts
function vcs_update_check_conflicts() {
	vcs_int_setup
	case "${VCS}" in
		svn)
			OUTPUT="$(svn up $*)" || die "svn update failed"
			STATUS=`echo ${OUTPUT} | grep "\<C\>"`
			echo "${OUTPUT}"
			;;
		git)
			OUTPUT="$(git pull $*)" || die "git pull failed"
			STATUS=`echo ${OUTPUT} | grep "\<C\>"`
			echo "${OUTPUT}"
			;;
		cvs)
			OUTPUT="$(cvs up $*)" || die "cvs update failed"
			STATUS=`echo ${OUTPUT} | grep "\<C\>"`
			echo "${OUTPUT}"
			;;
		fake)
			;;
		*)
			if [ -n "${VCS_FATAL_ERRORS}" ]; then
				die "Unknown VCS for ${PWD}"
			else
				echo "Unknown VCS for ${PWD}"
			fi
			;;
	esac
}

# get status on something in a VCS
function vcs_status() {
	vcs_int_setup
	case "${VCS}" in
		svn)
			svn status $* || die "svn status failed"
			;;
		git)
			git status $*
			;;
		cvs)
			cvs -nq up $* || die "cvs status failed"
			;;
		fake)
			;;
		*)
			if [ -n "${VCS_FATAL_ERRORS}" ]; then
				die "Unknown VCS for ${PWD}"
			else
				echo "Unknown VCS for ${PWD}"
			fi
			;;
	esac
}

# diff something in a VCS
function vcs_diff() {
	vcs_int_setup
	case "${VCS}" in
		svn)
			svn diff $* || die "svn diff failed"
			;;
		git)
			git diff $* || die "git diff failed"
			;;
		cvs)
			cvs diff $* || die "cvs diff failed"
			;;
		fake)
			;;
		*)
			if [ -n "${VCS_FATAL_ERRORS}" ]; then
				die "Unknown VCS for ${PWD}"
			else
				echo "Unknown VCS for ${PWD}"
			fi
			;;
	esac
}

# Do a changelog
function vcs_echangelog() { 
	vcs_int_setup
	case "${VCS}" in
		svn)
			VCS_ECHANGELOG=echangelog
			;;
		git)
			VCS_ECHANGELOG=echangelog
			;;
		cvs)
			VCS_ECHANGELOG=echangelog
			;;
		fake)
			VCS_ECHANGELOG="echo fake " 
			;;
		*)
			if [ -n "${VCS_FATAL_ERRORS}" ]; then
				die "Unknown VCS for ${PWD}"
			else
				echo "Unknown VCS for ${PWD}"
			fi
			;;
	esac

	if [ -n "${VCS_COMMITFILE}" ]; then
		ECHANGELOG_EDITOR= ${VCS_ECHANGELOG} < ${VCS_COMMITFILE} || die "${VCS_ECHANGELOG} failed"
	elif [ -n "${VCS_COMMITMSG}" ]; then
		${VCS_ECHANGELOG} "${VCS_COMMITMSG}" || die "${VCS_ECHANGELOG} died"
	fi
}

# See if a file is under version control
function vcs_is_added() {
	vcs_int_setup
	case "${VCS}" in
		svn)
			OUTPUT=$(svn info $@ | grep Path:)
			;;
		git)
			OUTPUT=$(git log $@ | grep commit)
			;;
		cvs)
			OUTPUT=$(cvs status $@ 2>/dev/null | grep Status | grep -v Unknown)
			;;
		fake)
			OUTPUT="foo"
			;;
		*)
			if [ -n "${VCS_FATAL_ERRORS}" ]; then
				die "Unknown VCS for ${PWD}"
			else
				echo "Unknown VCS for ${PWD}"
			fi
			;;
	esac

	if [ -z "${OUTPUT}" ]; then
		return 1
	fi
	return 0
}

# Move a file from one name to another
function vcs_mv() {
	vcs_int_setup
	case "${VCS}" in
		svn)
			svn mv ${VCS_INT_FORCE} $1 $2 || die "svn mv failed"
			;;
		git)
			git mv ${VCS_INT_FORCE} $1 $2 || die "git mv failed"
			;;
		cvs)
			# CVS doesn't do move...
			cp $1 $2 || die "cp failed"
			vcs_add $2 || die "cvs add failed"
			vcs_rm $1 || die "cvs rm failed"
			;;
		fake)
			mv $1 $2 || die "mv failed"
			;;
		*)
			if [ -n "${VCS_FATAL_ERRORS}" ]; then
				die "Unknown VCS for ${PWD}"
			else
				echo "Unknown VCS for ${PWD}"
			fi
			;;
	esac
}
# Copy a file from one name to another
function vcs_cp() {
	vcs_int_setup
	case "${VCS}" in
		svn)
			svn cp $1 $2 || die "svn cp failed"
			;;
		git)
			# Can't copy in git yet...
			cp $1 $2 || die "cp failed"
			vcs_add $2 || die "git add failed"
			;;
		cvs)
			# CVS doesn't do copy...
			cp $1 $2 || die "cp failed"
			vcs_add $2 || die "cvs add failed"
			;;
		fake)
			cp $1 $2 || die "cp failed"
			;;
		*)
			if [ -n "${VCS_FATAL_ERRORS}" ]; then
				die "Unknown VCS for ${PWD}"
			else
				echo "Unknown VCS for ${PWD}"
			fi
			;;
	esac
}
# Revert to last checked in state
function vcs_revert() {
	vcs_int_setup
	case "${VCS}" in
		svn)
			svn revert $* || die "svn revert failed"
			;;
		git)
			git reset --hard HEAD $* || die "git reset failed"
			;;
		cvs)
			# CVS doesn't do revert...
			rm $* || die "rm failed"
			vcs_update $* || die "cvs up failed"
			;;
		fake)
			;;
		*)
			if [ -n "${VCS_FATAL_ERRORS}" ]; then
				die "Unknown VCS for ${PWD}"
			else
				echo "Unknown VCS for ${PWD}"
			fi
			;;
	esac
}
