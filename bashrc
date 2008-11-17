# skeleton .bashrc

# Set up path.  Need ${HOME}/.scripts and ~/bin
export PATH=${HOME}/.scripts:${HOME}/bin:${PATH}

# Bash completion addons
[ -f /etc/profile.d/bash-completion ] && . /etc/profile.d/bash-completion

# Set up the main aliases
source ${HOME}/.scripts/aliases

# Give group write by default
umask 002

# Environment for various things
export LC_ALL=en_US.utf8
export LC_COLLATE=C
export LESS="-eFfgimnrsX -j2 -z-3"
export CVS_RSH=ssh
export MANPAGER="less -sr"
export LESSCHARSET="utf-8"
export EDITOR=vim
export EMAIL="dang@fprintf.net"
export MAILCHECK=-1
export MOZILLA_NEWTYPE="tab"
export ECHANGELOG_USER="Daniel Gryniewicz <dang@gentoo.org>"
# Keep gnome-autogen from running configure
export NOCONFIGURE=yes

# history
shopt -s histappend
export HISTCONTROL="erasedups"

# Update LINES and COLUMNS after each command
shopt -s checkwinsize

# per-box customizations.  These are done *after* all env settings (so those can be overridden) and
# *before* any prompt settings, so those can be set up
[ -f ${HOME}/.bash_local ] && . ${HOME}/.bash_local

# Prompts
if [ "${USER}" = "root" ]; then
   	PCHAR="#"
else
	PCHAR=">"
fi
# For systems without color:
#PS1="[ $BOXNAME] "`tput bold`'${PWD##*/}'`tput sgr0`" > "
# Colors:
# 	30 - grey
# 	31 - red
# 	32 - green
# 	33 - yellow
# 	34 - blue
# 	35 - purple
# 	36 - cyan
# 	37 - white
if [ -z "${COLOR1}" ]; then
	# Default colors are blue/red
	COLOR1=34
	COLOR2=31
fi
PCOLOR1="\[\033[1;${COLOR1}m\]"
PCOLOR2="\[\033[1;${COLOR2}m\]"
PCOLORN="\[\033[0m\]"
#PS1="${PCOLOR1}[${PCOLOR2}\$(date +%H%M)${PCOLOR1}][\h] ${PCOLOR2}\w${PCOLORN}${PCHAR} "
#PS1='\e[1;${COLOR1}m[\A \h] \e[1;${COLOR2}m\W\e[0m${PCHAR} '
#PS1='[${COLOR1};1m[\A \h] [${COLOR2};1m\W[0m${PCHAR} '
#PS1='\[\033[${COLOR1};1m\][\A \h] \[\033[${COLOR2};1m\]\W\[\033[0m\]${PCHAR} '
#PS1='\[\033[01;${COLOR1}m\][\A \h]\[\033[01;${COLOR2}m\] \W\[\033[00m\]${PCHAR} '
#PS1='\[\033[01;${COLOR1}m\]\D{%H:%M%S} \h\[\033[01;${COLOR2}m\] \W \[\033[00m\]${PCHAR} '
PS1="${PCOLOR1}[${PCOLOR1}\A${PCOLOR1}\
${PCOLOR1} ${PCOLOR1}\h${PCOLOR1}]\
 ${PCOLOR2}\W\
${PCOLORN}${PCHAR}${PCOLORN} "

# Core file size
[ -z "${CORESIZE}" ] && CORESIZE=0
ulimit -c ${CORESIZE}

# ssh/gpg
eval `keychain --quiet --eval`
