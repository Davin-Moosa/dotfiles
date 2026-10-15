if status is-interactive
    # Commands to run in interactive sessions can go here
end

abbr -a !! --position anywhere -f cmd_prev

abbr -a dotcd -r '^\.\.+$' -f cd_dots

abbr -a pyso 'git-auth; source (git rev-parse --show-toplevel)/.venv/bin/activate.fish'

abbr -a l 'eza -lh'
abbr -a la 'eza -alh'
abbr -a ll 'eza -alh'
abbr -a ls 'eza -a'

abbr -a vi 'nvim'
abbr -a vim 'nvim'

set -g fish_greeting
set -g fish_key_bindings fish_vi_key_bindings

set -gx EDITOR nvim
set -gx VISUAL nvim

set -gx PROTON_ENABLE_WAYLAND 1

fzf --fish | source
zoxide init fish | source
