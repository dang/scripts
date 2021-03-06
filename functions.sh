#
# A useful set of bash functions for my scripts
#

# if is_interactive; then echo "interactive" fi
#
# Check for an interactive shell
if [ -z "$(declare -F | grep "\<is_interactive\>")" ]; then
is_interactive() {
	case $- in
		*i*)
			# Don't die in interactive shells
			return 0
			;;
		*)
			return 1
			;;
	esac
}
fi

# if can_die; then exit
#
# Check to see if it's legal to exit during die
if [ -z "$(declare -F | grep "\<can_die\>")" ]; then
can_die() {
	if (( BASH_SUBSHELL > 0 )); then
		echo -e "\t\tbaby shell; exiting"
		return 0
	fi
	if ! is_interactive; then
		return 0
	fi
	return 1
}
fi

# command | die "message"
#
# Print a message and exit with failure
if [ -z "$(declare -F | grep "\<die\>")" ]; then
die() {
	echo "Failed: $@"
	if [ ! -z "$(declare -F | grep "DFGcleanup")" ]; then
		DFGcleanup "$@"
	fi
	if can_die; then
		exit 1
	fi
}
fi

# How do use die properly to handle both interactive and script useage:
#testfunc() {
#	(
#		command1 || die "command1 failed"
#		command2 || die "command2 failed"
#		command3 || die "command3 failed"
#	)
#	return $?
#}
#
# Optionally, the return can be replaced with this:
#	local val=$?
#	[[ "${val}" == "0" ]] || die
#	return ${val}
# This will cause the contaning script to abort


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
#source ${SCRIPTS}/functions.sh
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
#source ${SCRIPTS}/functions.sh
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
	if [ -n "$(svn info 2>/dev/null | grep Path)" ]; then
		VCS="svn"
	elif [ -n "$(git rev-parse --git-dir 2>/dev/null)" ]; then
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
			colorcvs rm $* || die "cvs rm failed (cvs rm)"
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
			colorcvs add $* || die "cvs add failed"
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
			if [ -z "${VCS_NOPUSH}" ]; then
				git push || die "git push failed"
			fi
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
			colorcvs up $* || die "cvs update failed"
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
			colorcvs -nq up $* 2>/dev/null || die "cvs status failed"
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
			colorcvs diff $* || die "cvs diff failed"
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
			# Don't use echangelog on git
			return
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
		EDITOR= ECHANGELOG_EDITOR= ${VCS_ECHANGELOG} < ${VCS_COMMITFILE} || die "${VCS_ECHANGELOG} failed"
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
			if [ -n "$*" ] ; then
				FILES="$*"
			else
				# git uses checkout . for recursive revert
				FILES="."
			fi
			git checkout ${FILES} || die "git checkout failed"
			;;
		cvs)
			# CVS doesn't do revert...
			rm $*
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
# annotate a file
function vcs_annotate() {
	vcs_int_setup
	case "${VCS}" in
		svn)
			svn annotate $* || die "svn annotate failed"
			#svn annotate --use-merge-history $* || die "svn annotate failed"
			;;
		git)
			git annotate $* | sed -r 's/\<([0-1][0-9]|[2][0-3]):([0-5][0-9]):([0-5][0-9])\>//' | sed 's/ +0000//' || die "git annotate failed"
			;;
		cvs)
			colorcvs annotate $* || die "cvs annotate failed"
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

# get log messages for a file
function vcs_log() {
	vcs_int_setup
	VERSION=$1
	shift
	case "${VCS}" in
		svn)
			svn log -r ${VERSION} || die "svn log failed"
			;;
		git)
			git show ${VERSION} || die "git log failed"
			;;
		cvs)
			# CVS doesn't do revert...
			colorcvs log -r ${VERSION} $* || die "cvs log failed"
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

# blame a line in a file
function vcs_blame() {
	vcs_int_setup
	file=$1
	line=$2
	case "${VCS}" in
		git)
			tig blame $file +$line
			;;
		svn|cvs)
			blamename=`mktemp`
			logname=`mktemp`
			vcs_annotate $file > $blamename
			if [ -z "${line}" ]; then
				echo "No version" > ${logname}
				line="0"
			else
				version=`awk '(NR == line){print $1}' line=${line} ${blamename}`
				echo "version ${version}"
				vcs_log ${version} ${file} > ${logname}
			fi

			vim +${line} -o ${blamename} ${logname}
			rm ${blamename} ${logname}
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

#
# Set up portage variables
function portage_setup() {
	BASEDIR="/"
	if [ -n "${1}" ]; then
		BASEDIR="${1}"
		shift
	fi

	if [ -f "${BASEDIR}/etc/make.globals" ]; then
		source ${BASEDIR}/etc/make.globals
	elif [ -f "${BASEDIR}/usr/share/portage/config/make.globals" ]; then
		source "${BASEDIR}/usr/share/portage/config/make.globals"
	else
		die "Could not find make.globals"
	fi
	if [ -f "${BASEDIR}/etc/make.conf" ]; then
		source ${BASEDIR}/etc/make.conf
	elif [ -f "${BASEDIR}/etc/portage/make.conf" ]; then
		source "${BASEDIR}/etc/portage/make.conf"
	else
		die "Could not find make.conf"
	fi

	if [ -z "${PORTDIR}" ]; then
		die "No PORTDIR.  Are make.globals and make.conf broken?"
	fi
	if [ -z "${PORTAGE_TMPDIR}" ]; then
		die "No PORTAGE_TMPDIR.  Are make.globals and make.conf broken?"
	fi
	if [ -z "${DISTDIR}" ]; then
		die "No DISTDIR.  Are make.globals and make.conf broken?"
	fi
}
