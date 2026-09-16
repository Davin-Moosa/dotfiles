if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_greeting
end

function git-auth
  eval (ssh-agent -c)
  ssh-add ~/.ssh/id_gitauth
end

function man
  command man $argv | bat -pl man
end

function echo_hist
  echo $history[1]
end
abbr -a !! --position anywhere -f echo_hist

function echo_dots
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
abbr -a dotcd -r '^\.\.+$' -f echo_dots

abbr -a l 'eza -alh'
abbr -a la 'eza -alh'
abbr -a ll 'eza -alh'
abbr -a ls 'eza -a'

abbr -a ncg 'sudo nix-collect-garbage -d'
abbr -a nfu 'sudo nix flake update --flake /etc/nixos'
abbr -a nrs 'sudo nixos-rebuild switch'
abbr -a nso 'sudo nix store optimise'

abbr -a pyso 'source (git rev-parse --show-toplevel)/.venv/bin/activate.fish'

abbr -a vi 'nvim'
abbr -a vim 'nvim'

set -g fish_key_bindings fish_vi_key_bindings

set -gx EDITOR nvim
set -gx VISUAL nvim

fzf --fish | source
zoxide init fish | source
