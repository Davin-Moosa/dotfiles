if status is-interactive
# Commands to run in interactive sessions can go here
end

function fish_greeting
end

function man
  command man $argv | bat -pl man
end

fish_vi_key_bindings

alias auth="eval (ssh-agent -c) && ssh-add ~/.ssh/id_github"
alias ls="eza -A --icons --group-directories-first"
alias vi="nvim"
alias vim="nvim"

set -gx EDITOR nvim
set -gx VISUAL nvim

set -gx TERMINAL ghostty

fzf --fish | source
zoxide init fish | source
