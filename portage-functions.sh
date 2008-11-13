#!/bin/bash
#
# Useful functions and setup for scripts dealing with portage.
#
# Needs: sys-apps/pkgcore
#
# Note: this sources make.conf and make.defaults
#

#
# Fake functions to allow ebuild sourcing
function inherit() {
	true
}

# Fallback defaults
DISTDIR="/usr/portage/distfiles"
PORTDIR="/usr/portage"

# Get info from make.conf
source /etc/make.conf

# Get PORTDIR.  First, see if the PWD is in one of the directories in ${PORTDIR}
# or ${PORTDIR_OVERLAY}  If it is, use that as PORTDIR.  Otherwise, fall back on
# PORTDIR specified in /etc/make.conf, or on the default above.
for i in ${PORTDIR} ${PORTDIR_OVERLAY}; do
	MY_PORTDIR=`echo ${PWD} | /bin/grep -Fo "${i}"`
	if [ -n "${MY_PORTDIR}" ]; then
		PORTDIR=${MY_PORTDIR}
		break;
	fi
done

#
# Get the directory a package would live in
function portpkgdir() {
	RETVAL=
	PKGDIR_PWD=`pwd`
	#PKGDIR_QUERY=`pquery --repo ${PORTDIR} -nm $*`
	PKGDIR_QUERY=`eix -p --only-names $*`
	echo "$PKGDIR_QUERY"
	PKGDIR_MULTI=
	for i in ${PKGDIR_QUERY}; do
		testdir="${PORTDIR}/$i"
		if [ ! -d "${testdir}" ]; then
			continue;
		fi
		RETVAL="${testdir}"
		if [ "${PKGDIR_PWD}" == "${testdir}" ]; then
			break;
		elif [ -z "${PKGDIR_MULTI}" ]; then
			PKGDIR_MULTI="yes"
		else
			RETVAL=
			die "Multiple directories for $*: ${PKGDIR_QUERY}"
		fi
	done
}

#
# cd to a package location by name in a portdir
function portcd() {
	portpkgdir $@
	if [ -n "${RETVAL}" ]; then
		cd "${RETVAL}"
	fi
}

#
# Given that you are in a directory for a package, get the category of it and
# set it in PORT_CATEGORY
function port_category() {
	PORT_CATEGORY=$(basename $(dirname ${PWD}))
}

#
# splitname (pvr|pn|pv|revision) package-name-version-revision
# Borrowed from /usr/bin/ebump
#
# Removed!  Use qatom instead
#
