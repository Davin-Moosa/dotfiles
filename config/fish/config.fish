if status is-interactive
    # Commands to run in interactive sessions can go here
end

function prev_cmd
  echo $history[1]
end
abbr -a !! --position anywhere -f prev-cmd

function cd_prev
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
abbr -a cd_dots -r '^\.\.+$' -f cd_prev

abbr -a l 'eza -alh'
abbr -a la 'eza -alh'
abbr -a ll 'eza -alh'
abbr -a ls 'eza -a'

abbr -a pyso 'git-auth; source (git rev-parse --show-toplevel)/.venv/bin/activate.fish'

abbr -a vi 'nvim'
abbr -a vim 'nvim'

set -g fish_key_bindings fish_vi_key_bindings

set -gx EDITOR nvim
set -gx VISUAL nvim

set -gx PROTON_ENABLE_WAYLAND 1

fzf --fish | source
zoxide init fish | source
