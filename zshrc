setopt promptsubst

bindkey -v
bindkey -M vicmd 'R' custom-vi-replace

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

bindkey '\e[3~' delete-char
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
bindkey -M emacs "^r" history-incremental-search-backward
bindkey -M viins "^[d" kill-word
bindkey -M vicmd "^[d" kill-word
bindkey -M viins "^u" backward-kill-line
bindkey -M vicmd "^u" backward-kill-line
bindkey -M viins "^w" backward-kill-word
bindkey -M vicmd "^w" backward-kill-word

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

setopt completealiases

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
autoload -Uz compinit
compinit
# Make git completion working for 'g'.
compdef _git g=git
compdef _git gc=git-checkout

zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=100000
setopt appendhistory autocd extendedglob nomatch notify

# Execute everything in .zsh directory.
if [ -e $HOME/.zsh ]; then
  for sc in $HOME/.zsh/* ; do
    echo 'Executing' $sc
    . $sc
  done
fi
