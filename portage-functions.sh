#!/bin/bash
#
# Useful functions and setup for scripts dealing with portage.
#
# Needs: sys-apps/pkgcore
# Needs: app-portage/portage-utils
# Needs: app-portage/eix
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
portage_setup

# Get PORTDIR.  First, see if the PWD is in one of the directories in ${PORTDIR}
# or ${PORTDIR_OVERLAY}  If it is, use that as PORTDIR.  Otherwise, fall back on
# PORTDIR specified in /etc/make.conf, or on the default above.
for __x in ${PORTDIR} ${PORTDIR_OVERLAY}; do
	MY_PORTDIR=`echo ${PWD} | /bin/grep -Fo "${__x}"`
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
	getpcn $*
	echo "${PCN}"
	#PKGDIR_QUERY=`pquery --repo ${PORTDIR} -nm $PCN`
	PKGDIR_QUERY=`eix -p --only-names $PCN`
	echo "$PKGDIR_QUERY"
	PKGDIR_MULTI=
	for __x in ${PKGDIR_QUERY}; do
		testdir="${PORTDIR}/$__x"
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
			die "Multiple directories for $PCN: ${PKGDIR_QUERY}"
		fi
	done
}

#
# cd to a package location by name in a portdir
function portcd() {
	portpkgdir $@
	if [ -n "${RETVAL}" ]; then
		cd "${RETVAL}"
	elif [ -d "${PORTDIR}/$*" ]; then
		cd "${PORTDIR}/$*"
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

#
# Set PC with the package category of the given atom
function getpc() {
	PC=$(qatom -C $1 | awk '{print $1}')
}

#
# Set PN with the package name of the given atom
function getpn() {
	PN=$(qatom -C $1 | awk '{print $2}')
}

#
# Set PV with the package version of the given atom
function getpv() {
	PV=$(qatom -C $1 | awk '{print $3}')
}

#
# Set PR with the package revision of the given atom
function getpr() {
	PR=$(qatom -C $1 | awk '{print $4}')
}

#
# Set PVR with the package version-revision
function getpvr() {
	GPVRPV=${PV}
	GPVRPR=${PR}
	getpv $1
	getpr $1
	if [ -n "${PR}" ]; then
		PVR="${PV}-${PR}"
	else
		PVR="${PV}"
	fi
	PV=${GPVRPV}
	PR=${GPVRPR}
}

#
# Set PCN with the package category/name
function getpcn() {
	_xpc=$(qatom -C $1 | awk '{print $1}')
	_xpn=$(qatom -C $1 | awk '{print $2}')
	if [ "${_xpc}" != "(null)" ]; then
		PCN="${_xpc}/${_xpn}"
	else
		PCN=${_xpn}
	fi
}

function danglop_current() {
	ATOM=$(sudo qlop -Cc | head -n1 | awk '{print $2}')
	if [ -z "${ATOM}" ]; then
		echo "None"
		return
	fi
	getpc ${ATOM}
	getpvr ${ATOM}
	getpcn ${ATOM}
        #echo "${PC}"
        #echo "${PVR}"
        #echo "${PCN}"
	ELAPSED=$(sudo qlop -Cc | awk '(/elapsed/) {print $2 " " $4 " " $6}')
	E1=$(echo ${ELAPSED} | awk '{print $1}')
	E2=$(echo ${ELAPSED} | awk '{print $2}')
	E3=$(echo ${ELAPSED} | awk '{print $3}')
	if [ -n "${E3}" ]; then
		# hours, min, sec
		ETSEC=$((${E1} * 60  * 60 + ${E2} * 60 + ${E3}))
		EMIN=$(printf "%02d" ${E2})
		ESEC=$(printf "%02d" ${E3})
		TIMEPASSED="${E1}:${EMIN}:${ESEC}"
	elif [ -n "${E2}" ]; then
		ETSEC=$((${E1} * 60 + ${E2}))
		ESEC=$(printf "%02d" ${E2})
		TIMEPASSED="${E1}:${ESEC}"
	else
		ETSEC=${E1}
		ESEC=$(printf "%02d" ${ETSEC})
		TIMEPASSED="0:${ESEC}"
	fi
	TOTSEC=$(sudo qlop -tC ${PCN} | awk '{print $2}')
	if [ -n "${TOTSEC}" ]; then
		TOTSECLEFT=$((${TOTSEC} - ${ETSEC}))
		if ((${TOTSECLEFT} < 0)); then
			TOTSECLEFT=$((-${TOTSECLEFT}))
			OVERRUN="true"
		fi
		MINLEFT=$((${TOTSECLEFT} / 60))
		SECLEFT=$((${TOTSECLEFT} % 60))
		LSEC=$(printf "%02d" ${SECLEFT})
		if [ -z "${OVERRUN}" ]; then
			TIMELEFT="${MINLEFT}:${LSEC}"
		else
			TIMELEFT="-${MINLEFT}:${LSEC}"
		fi
	else
		TIMELEFT="Unknown"
	fi
	echo "${PCN}-${PVR}"
	echo "${TIMEPASSED}"
	echo "${TIMELEFT}"

}
