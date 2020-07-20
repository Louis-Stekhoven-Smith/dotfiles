### load scripts ###
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# bash-completion
source /usr/local/etc/bash_completion.d/git-completion.bash

### Style terminal ###
export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$(parse_git_branch)\$(parse_git_dirty)\[\033[00m\] 💎 "
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

### Path vard ###
export PATH=$JAVA_HOME/bin:$PATH
export PATH=$PATH:/Users/lstekhovensmith/Applications/apache-maven-3.5.4/bin
export PATH=$PATH:/Applications/Firefox.app/Contents/MacOS
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

##### PROXIES!!!!!!!! ########
alias aconex-vpn-off='/opt/cisco/anyconnect/bin/vpn disconnect mel-vpn.aconex.com && scselect clear-corporate'
alias aconex-vpn-status='/opt/cisco/anyconnect/bin/vpn state mel-vpn.aconex.com'
aconex-vpn-on() {
  scselect clear-internet && sleep 5 && /opt/cisco/anyconnect/bin/vpn -s connect mel-vpn.aconex.com 
}


export http_proxy=http://www-proxy-syd.au.oracle.com:80
export https_proxy=http://www-proxy-syd.au.oracle.com:80
export no_proxy=localhost,artifacthub-tip.oraclecorp.com,artifacthub.oraclecorp.com,100.104.176.23,cegbuacx-docker-virtual.dockerhub-den.oraclecorp.com
export HTTP_PROXY=http://www-proxy-syd.au.oracle.com:80
export HTTPS_PROXY=http://www-proxy-syd.au.oracle.com:80
export NO_PROXY=localhost,artifacthub-tip.oraclecorp.com,artifacthub.oraclecorp.com,100.104.176.23,cegbuacx-docker-virtual.dockerhub-den.oraclecorp.com

unset_proxys() {
    unset http_proxy &&  unset http_proxys && unset no_proxy && unset HTTP_PROXY && unset HTTP_PROXY && unset NO_PROXY
}

### Enviroment vars ###
export nexusAconexUsername=USERNAME
export nexusAconexPassword=PASSWORD
export ARTIFACT_REPOSITORY_USERNAME=$nexusAconexUsername
export ARTIFACT_REPOSITORY_PASSWORD=$nexusAconexPassword 
export JIRA_HOME=/Users/lstekhovensmith/dev/jira/home
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_201.jdk/Contents/Home
export NVM_DIR="$HOME/.nvm"

export VAGRANT_USE_VAGRANT_TRIGGERS=true

# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
# http://stackoverflow.com/questions/9457233/unlimited-bash-history
export HISTFILESIZE=100000
export HISTSIZE=100000
#export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
# http://superuser.com/questions/575479/bash-history-truncated-to-500-lines-on-each-login
#export HISTFILE=~/.bash_eternal_history
# Force prompt to write history after every command.
# http://superuser.com/questions/20900/bash-history-loss
#PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

##### Helper methods ######
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

function parse_git_dirty {
  STATUS="$(git status 2> /dev/null)"
  if [[ $? -ne 0 ]]; then printf ""; return; else printf "[";
      if echo ${STATUS} | grep -c "nothing to commit" &> /dev/null; then printf "😇"; else printf ""; fi
      if echo ${STATUS} | grep -c "diverged"        &> /dev/null; then printf "😱"; else printf ""; fi
      if echo ${STATUS} | grep -c "Changes"         &> /dev/null; then printf "⚠️ "; else printf ""; fi
      if echo ${STATUS} | grep -c "branch is ahead" &> /dev/null; then printf "🎁"; else printf ""; fi
      if echo ${STATUS} | grep -c "branch is behind" &> /dev/null; then printf "💽"; else printf ""; fi
      if echo ${STATUS} | grep -c "Untracked files" &> /dev/null; then printf "📎"; else printf ""; fi
      printf "]"
  fi
}

cdls() { cd "$@" && ls; }


############################### Alias
alias build='mvn -e -Dmaven.artifact.threads=10 -Dcheckstyle.skip -Dpmd.skip -DskipTests clean install -T 4.0C && terminal-notifier -title "Bab Clean Install" -message "Finished" -sound default'
alias ll='ls -lash'
###########   GIT   ############
alias gitlist='printf "ga=git add 
gc=git commit 
gcm=git commit -m 
gs=git status
gits=git status
gp=git pull --rebase
gd=git diff 
gds=git diff --staged
gpush=git push 
grh=git reset HEAD 
gco=git checkout -- 
gppp=git stash && git pull --rebase && git stash pop && git push
gwhat=show 10 must recent branches
"'

alias ga='git add '
alias gc='git commit '
alias gcm='git commit -m '
alias gs='git status'
alias gits='git status'
alias gp='git pull --rebase'
alias gd='git diff '
alias gds='git diff --staged'
alias gpush='git push '
alias grh='git reset HEAD '
alias gco='git checkout -- '
alias gppp='git stash && git pull --rebase && git stash pop && git push'
alias gwhat='for branch in `git branch -r | grep -v HEAD`;do echo -e `git show --format="%ci %cr" $branch | head -n 1` \\t$branch; done | sort -r | grep origin | head -n 10'

###########  QA BOXES ############
## ADD build DR repo and other resources I may be unaware of

export BASTION=bastion-ssvc301.awsnp.aconex.cloud

tools() {

    if [ $1 = "list" ]
    then
        echo "Commands 
        [bastion] - no args (Connect to bastion for sentinal)
        [consul] - no args (Open consul for sentinal QA's)
        [deploy] - no args (Opens jenkins for deploying to sentinal QA)
        [qa_database] - provide qa number e.g 301/302 (Create tunnel to a qa dabase box)
        [nexus] - no args (Connect to build.acx.com) " 
    fi
    if [ $1 = "bastion" ]
    then
        ssh -A $BASTION 
    fi

    if [ $1 = "consul" ]
    then
        ssh -f $BASTION 8025:consul-elb.ssvc301.apse2.internal.aconexgov.com:80 -N; open http://localhost:8025
    fi

    if [ $1 = "deploy" ]
    then
        ssh -f $BASTION -A -L8080:jenkins-master-platform:443 -N; open https://localhost:8080
    fi

    ##TODO add null check for $2
    if [ $1 = "qa_database" ]
    then
        ssh -f $BASTION -A -L3$2:db1.sentqa$2.apse2.internal.aconexgov.com:3389 -N; echo "PORT:3$2"
    fi
    
    if [ $1 = nexus ] 
    then 
        ssh -A build.qa.acx
    fi
}
####### Lock computer #######
alias lock='/System/Library/CoreServices/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine'
############################### 

# Load SSH keys
if ! ssh-add -l; then
    lock_file=/tmp/zshrc_ssh_add_lock
    if [ ! -f $lock_file ]; then
        touch $lock_file
        ssh-add ~/.ssh/id_rsa
        rm $lock_file
    fi
fi
 

# Copyright (c) 2009 rupa deadwyler. Licensed under the WTFPL license, Version 2

# maintains a jump-list of the directories you actually use
#
# INSTALL:
#     * put something like this in your .bashrc/.zshrc:
#         . /path/to/z.sh
#     * cd around for a while to build up the db
#     * PROFIT!!
#     * optionally:
#         set $_Z_CMD in .bashrc/.zshrc to change the command (default z).
#         set $_Z_DATA in .bashrc/.zshrc to change the datafile (default ~/.z).
#         set $_Z_NO_RESOLVE_SYMLINKS to prevent symlink resolution.
#         set $_Z_NO_PROMPT_COMMAND if you're handling PROMPT_COMMAND yourself.
#         set $_Z_EXCLUDE_DIRS to an array of directories to exclude.
#         set $_Z_OWNER to your username if you want use z while sudo with $HOME kept
#
# USE:
#     * z foo     # cd to most frecent dir matching foo
#     * z foo bar # cd to most frecent dir matching foo and bar
#     * z -r foo  # cd to highest ranked dir matching foo
#     * z -t foo  # cd to most recently accessed dir matching foo
#     * z -l foo  # list matches instead of cd
#     * z -e foo  # echo the best match, don't cd
#     * z -c foo  # restrict matches to subdirs of $PWD

[ -d "${_Z_DATA:-$HOME/.z}" ] && {
    echo "ERROR: z.sh's datafile (${_Z_DATA:-$HOME/.z}) is a directory."
}

_z() {

    local datafile="${_Z_DATA:-$HOME/.z}"

    # if symlink, dereference
    [ -h "$datafile" ] && datafile=$(readlink "$datafile")

    # bail if we don't own ~/.z and $_Z_OWNER not set
    [ -z "$_Z_OWNER" -a -f "$datafile" -a ! -O "$datafile" ] && return

    _z_dirs () {
        local line
        while read line; do
            # only count directories
            [ -d "${line%%\|*}" ] && echo "$line"
        done < "$datafile"
        return 0
    }

    # add entries
    if [ "$1" = "--add" ]; then
        shift

        # $HOME isn't worth matching
        [ "$*" = "$HOME" ] && return

        # don't track excluded directory trees
        local exclude
        for exclude in "${_Z_EXCLUDE_DIRS[@]}"; do
            case "$*" in "$exclude*") return;; esac
        done

        # maintain the data file
        local tempfile="$datafile.$RANDOM"
        _z_dirs | awk -v path="$*" -v now="$(date +%s)" -F"|" '
            BEGIN {
                rank[path] = 1
                time[path] = now
            }
            $2 >= 1 {
                # drop ranks below 1
                if( $1 == path ) {
                    rank[$1] = $2 + 1
                    time[$1] = now
                } else {
                    rank[$1] = $2
                    time[$1] = $3
                }
                count += $2
            }
            END {
                if( count > 9000 ) {
                    # aging
                    for( x in rank ) print x "|" 0.99*rank[x] "|" time[x]
                } else for( x in rank ) print x "|" rank[x] "|" time[x]
            }
        ' 2>/dev/null >| "$tempfile"
        # do our best to avoid clobbering the datafile in a race condition.
        if [ $? -ne 0 -a -f "$datafile" ]; then
            env rm -f "$tempfile"
        else
            [ "$_Z_OWNER" ] && chown $_Z_OWNER:$(id -ng $_Z_OWNER) "$tempfile"
            env mv -f "$tempfile" "$datafile" || env rm -f "$tempfile"
        fi

    # tab completion
    elif [ "$1" = "--complete" -a -s "$datafile" ]; then
        _z_dirs | awk -v q="$2" -F"|" '
            BEGIN {
                q = substr(q, 3)
                if( q == tolower(q) ) imatch = 1
                gsub(/ /, ".*", q)
            }
            {
                if( imatch ) {
                    if( tolower($1) ~ q ) print $1
                } else if( $1 ~ q ) print $1
            }
        ' 2>/dev/null

    else
        # list/go
        while [ "$1" ]; do case "$1" in
            --) while [ "$1" ]; do shift; local fnd="$fnd${fnd:+ }$1";done;;
            -*) local opt=${1:1}; while [ "$opt" ]; do case ${opt:0:1} in
                    c) local fnd="^$PWD $fnd";;
                    e) local echo=1;;
                    h) echo "${_Z_CMD:-z} [-cehlrtx] args" >&2; return;;
                    l) local list=1;;
                    r) local typ="rank";;
                    t) local typ="recent";;
                    x) sed -i -e "\:^${PWD}|.*:d" "$datafile";;
                esac; opt=${opt:1}; done;;
             *) local fnd="$fnd${fnd:+ }$1";;
        esac; local last=$1; [ "$#" -gt 0 ] && shift; done
        [ "$fnd" -a "$fnd" != "^$PWD " ] || local list=1

        # if we hit enter on a completion just go there
        case "$last" in
            # completions will always start with /
            /*) [ -z "$list" -a -d "$last" ] && builtin cd "$last" && return;;
        esac

        # no file yet
        [ -f "$datafile" ] || return

        local cd
        cd="$( < <( _z_dirs ) awk -v t="$(date +%s)" -v list="$list" -v typ="$typ" -v q="$fnd" -F"|" '
            function frecent(rank, time) {
                # relate frequency and time
                dx = t - time
                if( dx < 3600 ) return rank * 4
                if( dx < 86400 ) return rank * 2
                if( dx < 604800 ) return rank / 2
                return rank / 4
            }
            function output(matches, best_match, common) {
                # list or return the desired directory
                if( list ) {
                    cmd = "sort -n >&2"
                    for( x in matches ) {
                        if( matches[x] ) {
                            printf "%-10s %s\n", matches[x], x | cmd
                        }
                    }
                    if( common ) {
                        printf "%-10s %s\n", "common:", common > "/dev/stderr"
                    }
                } else {
                    if( common ) best_match = common
                    print best_match
                }
            }
            function common(matches) {
                # find the common root of a list of matches, if it exists
                for( x in matches ) {
                    if( matches[x] && (!short || length(x) < length(short)) ) {
                        short = x
                    }
                }
                if( short == "/" ) return
                for( x in matches ) if( matches[x] && index(x, short) != 1 ) {
                    return
                }
                return short
            }
            BEGIN {
                gsub(" ", ".*", q)
                hi_rank = ihi_rank = -9999999999
            }
            {
                if( typ == "rank" ) {
                    rank = $2
                } else if( typ == "recent" ) {
                    rank = $3 - t
                } else rank = frecent($2, $3)
                if( $1 ~ q ) {
                    matches[$1] = rank
                } else if( tolower($1) ~ tolower(q) ) imatches[$1] = rank
                if( matches[$1] && matches[$1] > hi_rank ) {
                    best_match = $1
                    hi_rank = matches[$1]
                } else if( imatches[$1] && imatches[$1] > ihi_rank ) {
                    ibest_match = $1
                    ihi_rank = imatches[$1]
                }
            }
            END {
                # prefer case sensitive
                if( best_match ) {
                    output(matches, best_match, common(matches))
                } else if( ibest_match ) {
                    output(imatches, ibest_match, common(imatches))
                }
            }
        ')"

        [ $? -eq 0 ] && [ "$cd" ] && {
          if [ "$echo" ]; then echo "$cd"; else builtin cd "$cd"; fi
        }
    fi
}

alias ${_Z_CMD:-z}='_z 2>&1'

[ "$_Z_NO_RESOLVE_SYMLINKS" ] || _Z_RESOLVE_SYMLINKS="-P"

if type compctl >/dev/null 2>&1; then
    # zsh
    [ "$_Z_NO_PROMPT_COMMAND" ] || {
        # populate directory list, avoid clobbering any other precmds.
        if [ "$_Z_NO_RESOLVE_SYMLINKS" ]; then
            _z_precmd() {
                (_z --add "${PWD:a}" &)
            }
        else
            _z_precmd() {
                (_z --add "${PWD:A}" &)
            }
        fi
        [[ -n "${precmd_functions[(r)_z_precmd]}" ]] || {
            precmd_functions[$(($#precmd_functions+1))]=_z_precmd
        }
    }
    _z_zsh_tab_completion() {
        # tab completion
        local compl
        read -l compl
        reply=(${(f)"$(_z --complete "$compl")"})
    }
    compctl -U -K _z_zsh_tab_completion _z
elif type complete >/dev/null 2>&1; then
    # bash
    # tab completion
    complete -o filenames -C '_z --complete "$COMP_LINE"' ${_Z_CMD:-z}
    [ "$_Z_NO_PROMPT_COMMAND" ] || {
        # populate directory list. avoid clobbering other PROMPT_COMMANDs.
        grep "_z --add" <<< "$PROMPT_COMMAND" >/dev/null || {
            PROMPT_COMMAND="$PROMPT_COMMAND"$'\n''(_z --add "$(command pwd '$_Z_RESOLVE_SYMLINKS' 2>/dev/null)" 2>/dev/null &);'
        }
    }
fi
