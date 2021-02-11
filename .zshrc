source $HOME/.profile
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source $HOME/dev/personal/zsh-plugins/zsh-z/zsh-z.plugin.zsh
autoload -U compinit && compinit
zstyle ':completion:*' menu select

source $HOME/dev/personal/zsh-plugins/vpn-status/.vpm-status.zsh

source $HOME/dev/personal/zsh-plugins/powerlevel10k/powerlevel10k.zsh-theme 
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS+=my_vpn

export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
