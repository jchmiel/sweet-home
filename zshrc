
function custom-vi-replace {
  REPLACE=1 && zle vi-replace && REPLACE=0
}
zle -N custom-vi-replace

function zle-line-init zle-keymap-select {
  zle reset-prompt
}
zle -N zle-line-init && zle -N zle-keymap-select

function zsh_mode {
  if [[ $KEYMAP == vicmd ]]; then
    echo "%F{green}N%f"
  elif [[ $REPLACE == 1 ]]; then
    echo "%F{red}R%f"
  else
    echo "%F{blue}$%f"
  fi
}

PROMPT='@%m %28<...<%~%B$(zsh_mode)%b '
PATH=$PATH:$HOME/bin

bindkey '\e[3~' delete-char
bindkey -e
bindkey -M vicmd 'R' custom-vi-replace
bindkey -M vicmd k down-line-or-history
bindkey -M vicmd h up-line-or-history
bindkey -M vicmd '^k' down-line-or-history
bindkey -M vicmd '^h' up-line-or-history
bindkey -M viins '^K' down-line-or-history
bindkey -M viins '^H' up-line-or-history
bindkey -M viins '`' vi-cmd-mode

bindkey -M vicmd '^A' beginning-of-line
bindkey -M vicmd '^E' end-of-line
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M vicmd v edit-command-line
bindkey -M viins "^[b" backward-word
bindkey -M vicmd "^[b" backward-word
bindkey -M viins "^[f" forward-word 
bindkey -M vicmd "^[f" forward-word 
bindkey -M viins '^r' history-incremental-search-backward
bindkey -M vicmd '^r' history-incremental-search-backward
bindkey -M viins "^[d" kill-word
bindkey -M vicmd "^[d" kill-word
bindkey -M viins "^u" backward-kill-line
bindkey -M vicmd "^u" backward-kill-line
bindkey -M viins "^w" backward-kill-word
bindkey -M vicmd "^w" backward-kill-word

bindkey -M emacs "^r" history-incremental-search-backward
bindkey -M emacs '^k' down-line-or-history
bindkey -M emacs '^h' up-line-or-history
# Don't kill the whole line with ^U
bindkey -M emacs "^U" kill-region

bindkey "\e[1~" beginning-of-line # Home
bindkey "\e[4~" end-of-line # End
bindkey "^[OH" beginning-of-line # Home
bindkey "^[OF" end-of-line # End
bindkey "^[OI" history-beginning-search-backward
bindkey "^[OG" history-beginning-search-forward
bindkey -M vicmd "^[B" bash-backward-word
bindkey -M viins "^[B" bash-backward-word
bindkey -M vicmd "^[F" bash-forward-word
bindkey -M viins "^[F" bash-forward-word


# Use vim to edit long lines.
autoload edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line

# Autoquote URLs.
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
autoload -Uz compinit
compinit
# Make git completion working for 'g'.
compdef _git g=git
compdef _git gc=git-checkout

zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

# history
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
# setopt SHARE_HISTORY

setopt AUTO_CD EXTENDED_GLOB NOMATCH NOTIFY
setopt COMPLETE_ALIASES
setopt PROMPT_SUBST


# Execute everything in .zsh directory.
if [ -e $HOME/.zsh ]; then
  for sc in $HOME/.zsh/* ; do
    echo 'Executing' $sc
    . $sc
  done
fi

autoload -Uz vcs_info
zstyle ':vcs_info:*' actionformats \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}]%f '
zstyle ':vcs_info:*' formats       \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'

zstyle ':vcs_info:*' enable git cvs svn

# or use pre_cmd, see man zshcontrib
vcs_info_wrapper() {
  vcs_info
  if [ -n "$vcs_info_msg_0_" ]; then
    echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
  fi
}
RPROMPT=$'$(vcs_info_wrapper)'


alias android-connect="mtpfs -o allow_other /media/GalaxyNexus"
alias android-disconnect="fusermount -u /media/GalaxyNexus"
