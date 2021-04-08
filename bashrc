GPG_TTY=$(tty)
export GPG_TTY

export TERM=xterm

git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

export PS1="\[\`if [[  \$? = "0" ]]; then echo '\e[32m\u@\h\e[0m'; else echo '\e[31m\u@\h\e[0m'; fi\`:\w \e[36m\$(git_branch)\e[0m\n\$ "
alias ls="ls --color=auto"
alias tmux="tmux -2"


