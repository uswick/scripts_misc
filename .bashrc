# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

########functions############
export HPX_HOME=$PWD

savepkgpath() {
    #do things with parameters like $1 such as
    #export PKG_CONFIG_PATH=$HPX_HOME/install_$1/lib/pkgconfig:$PKG_CONFIG_PATH
    if [ -n "$1" ]; then 
      echo "hpx saved PKG_CONFIG_PATH to $HPX_HOME/install_${1}/lib/pkgconfig"  	    
      export PKG_CONFIG_PATH=$HPX_HOME/install_$1/lib/pkgconfig:$PKG_CONFIG_PATH
    else
      echo "hpx saved PKG_CONFIG_PATH to $HPX_HOME/install/lib/pkgconfig"  	    
      export PKG_CONFIG_PATH=$HPX_HOME/install/lib/pkgconfig:$PKG_CONFIG_PATH
    fi	    
}

sethpxhome() {
    opt_ins="-i"

    if [ -n "$1" ]; then 
      HPX_HOME=$1
      if [ x$1=x$opt_ins ]; then 
        HPX_HOME=$PWD
    	echo "setting HPX_HOME to : [$HPX_HOME]"
        savepkgpath $2
	return
      fi	    
    else
      HPX_HOME=$PWD	    
    fi	    

    echo "setting HPX_HOME to : [$HPX_HOME]"
    
    if [ -n x$2 ]; then 
      if [ x$2 -eq x$opt_ins ]; then 
        savepkgpath $3
      else
        savepkgpath
      fi	    
    else
      savepkgpath
    fi  
}


mygrep() {
    #do things with parameters like $1 such as
    echo "grep for keyword [$1] in current dir"
    grep -rn $1 .
}

myfind() {
    #do things with parameters like $1 such as
    echo "find for file [$1] in current dir"
    find . -name $1 
}

myautoconf() {
    #do things with parameters like $1 such as
    ./configure --prefix=`pwd`/install $@ 
    echo ""
    echo ""
    echo "[./configure --prefix=`pwd`/install $@]"
}

myautoconf_save() {
    myautoconf $@
    echo "./configure --prefix=`pwd`/install $@" >> cmds
    echo "vconf $@" >> cmds
}

module load maui/3.3.1
#module load /u/zalewski/tools/modules/binutils/2.23.1
#module load /u/zalewski/tools/modules/gcc/4.8.2
#module load /u/zalewski/tools/modules/gdb/7.5.1
#module load /u/zalewski/tools/modules/infinipath-psm/3.2
#module load /u/zalewski/tools/modules/openmpi/1.7.4
#module load /u/zalewski/tools/modules/boost/1_53_0
#module load openmpi/1.8.1
#module load gcc/4.8.1
#module load openmpi/1.6.3
export HPX_USE_IB_DEV=mlx4_0
export HPX_USE_IB_PORT=1

#woraround for mpi .btr, no core dump issue
export IPATH_NO_BACKTRACE=1
#module load openmpi/1.8.1
module load gcc/4.9.2
#module load openmpi/1.8.4_thread
module load openmpi/1.10.1
module load valgrind/3.11.0

export PATH=/u/uswickra/CMake/cmake-3.4.0-rc1/install/bin:$PATH
export LD_LIBRARY_PATH=/u/uswickra/vim/dep/install/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/u/uswickra/hpx/hpx-libnbc/dep/libffi-3.2.1/x86_64-unknown-linux-gnu/.libs:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/u/uswickra/hpx/hpx-libnbc/hpx/install/lib/:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/u/uswickra/vim/dep/install/lib/pkgconfig
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/u/uswickra/hpx/hpx-libnbc/hpx/install/lib/pkgconfig
#export LD_LIBRARY_PATH=/u/uswickra/cswarm/tools/boost_1_63_0/BUILD/install/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/u/uswickra/cswarm/tools/boost_1_58_0/BUILD/install/lib:$LD_LIBRARY_PATH
#export PMTL_LICENSE_FILE=/u/uswickra/cswarm/license.pmtl.dat
export PMTL_LICENSE_FILE=/opt/pmtl4/license.pmtl.dat
#export LD_LIBRARY_PATH=/opt/photon/1.1/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/u/uswickra/cswarm/tools/photon/install/lib:$LD_LIBRARY_PATH

export VIMRUNTIME=/u/uswickra/vim/Vim/vim74/runtime
alias vim="find . -name *.swp -delete;~/vim/Vim/vim74/src/vim -g"
alias gpom="git push origin master"
alias vbash="vim ~/.bashrc"
alias vsource="source ~/.bashrc"
alias vconf=myautoconf
alias vconf_save=myautoconf_save
alias ugrep=mygrep
alias ufind=myfind

export PATH=/u/uswickra/vim/cscope/cscope-15.8b/install/bin:$PATH
export PATH=/u/uswickra/meld/meld-3.14.1/dep/install/bin:$PATH
export PATH=/u/uswickra/vim/git/Vim/scripts:$PATH
export MALLOC_CONF=lg_dirty_mult:-1
export MODULEPATH=$MODULEPATH:/u/uswickra/privatemodules/modulefiles

export PATH=/u/uswickra/autotools/new/bin:$PATH
#export PATH=/u/uswickra/uctags/ctags/install/bin:$PATH

alias savepath="export PKG_CONFIG_PATH=$PWD:$PKG_CONFIG_PATH"
alias sethpx="sethpxhome"

alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

#   mans:   Search manpage given in agument '1' for term given in argument '2' (case insensitive)
#           displays paginated result with colored search terms and two lines surrounding each hit.             Example: mans mplayer codec
#   --------------------------------------------------------------------
    mans () {
	            man $1 | grep -iC2 --color=always $2 | less
	}

alias path='echo -e ${PATH//:/\\n}'
#alias ls='ls -FGlAhprt'
alias qfind="find . -name "                 # qfind:    Quickly search for file
ff () { /usr/bin/find . -name "$@" ; }      # ff:       Find file under the current directory
finds () { /usr/bin/find . -name '*'"$@"'*' ; }  # ffs:      Find file whose name starts with a given string
finde () { /usr/bin/find . -name '*'"$@" ; }  # ffe:      Find file whose name ends with a given string
