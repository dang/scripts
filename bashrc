# .bashrc

# Install location for scripts
export SCRIPTS="${HOME}/.scripts"

pathprepend() {
	if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
		PATH="${1}${PATH:+:$PATH}"
	fi
}

pathappend() {
	if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
		PATH="${PATH:+$PATH:}${1}"
	fi
}

# Add scripts dir to path
pathprepend "${SCRIPTS}"

# Give group write by default
umask 002

# history
shopt -s histappend
export HISTCONTROL="erasedups"

# Update LINES and COLUMNS after each command
shopt -s checkwinsize

# Don't complete empty commands
shopt -s no_empty_cmd_completion

# CD with just a path
shopt -s autocd

run_scripts()
{
	for script in "$1"/*; do
		[ -x "${script}" ] || continue
		. "${script}"
	done
}

# Run the common env
run_scripts "${SCRIPTS}/bashrc.d/env"
# Run the local env
run_scripts "${HOME}/.bashrc.d"
# Run the actions
run_scripts "${SCRIPTS}/bashrc.d/actions"
# If there's a flavor, run that
if [ -d "${SCRIPTS}/bashrc.d/flavor/${FLAVOR}" ]; then
	run_scripts "${SCRIPTS}/bashrc.d/flavor/${FLAVOR}"
fi

# per-box customizations.  These are done *after* all env settings (so those can be overridden) and
# *before* any prompt settings, so those can be set up
[ -f ${HOME}/.bash_local ] && . ${HOME}/.bash_local

# Core file size
[ -z "${CORESIZE}" ] && CORESIZE=0
ulimit -c ${CORESIZE}

# ssh/gpg
if [ "${USER}" != "root" ]; then
	if [ -n "${SSH_ONLY_KEYRING}" ]; then
		KEYRING=$(echo ${SSH_AUTH_SOCK} | grep keyring)
		if [ -n "${KEYRING}" ]; then
			[ -x /usr/bin/keychain ] && eval `keychain --quiet --eval`
		fi
	else
		[ -x /usr/bin/keychain ] && eval `keychain --quiet --eval`
	fi
fi

# Terminal for TMUX
if [ "${TERM}" == "xterm" ]; then
	export TERM="xterm-256color"
fi
if [ -n "${TMUX}" ]; then
	export TERM="screen-256color"
fi

