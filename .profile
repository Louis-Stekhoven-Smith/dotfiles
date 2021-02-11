export PATH=$PATH:$HOME/bin
export http_proxy=
export no_proxy=
#export https_proxy=${http_proxy}
#export HTTP_PROXY=${http_proxy}
#export HTTPS_PROXY=${http_proxy}
#export NO_PROXY=$no_proxy

unset_proxys() {
    unset http_proxy &&  unset https_proxy && unset no_proxy && unset HTTPS_PROXY && unset HTTP_PROXY && unset NO_PROXY
}

cdls() { cd "$@" && ls; }

############################### Alias ###########################
########### Generic ############
alias ll='ls -lah'
########### Work ############


###########   GIT   ############
alias ga='git add '
alias gc='git commit '
alias gcm='git commit -am '
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
