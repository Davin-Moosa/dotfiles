if status is-interactive
# Commands to run in interactive sessions can go here
end

function fish_greeting
end

function man
  /usr/bin/man $argv | bat --style=-numbers --wrap never -l man
end

fish_vi_key_bindings

alias ls="eza -A --icons --group-directories-first"
alias auth="eval '$(ssh-agent -c)'; ssh-add ~/.ssh/id_github"

set -gx EDITOR nvim
set -gx VISUAL nvim

set -gx TERMINAL ghostty

fzf --fish | source
zoxide init fish | source
