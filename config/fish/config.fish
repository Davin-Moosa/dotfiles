if status is-interactive
    # Commands to run in interactive sessions can go here
end

function __hist_prev_cmd
    echo $history[1]
end
abbr -a '!!' --position anywhere -f __hist_prev_cmd

function __hist_prev_args
    string replace -r '^\S+\s*' '' -- "$history[1]"
end
abbr -a '!*' --position anywhere -f __hist_prev_args

function __cd_level
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
abbr -a __cd_up -r '^\.\.+$' -f __cd_dot_repeat

function git-auth
    eval (ssh-agent -c)
    ssh-add ~/.ssh/id_gitauth
end
abbr -a pyso 'git-auth; source (git rev-parse --show-toplevel)/.venv/bin/activate.fish'

abbr -a la 'eza -a'
abbr -a ll 'eza -alh'
abbr -a ls 'eza -lh'

abbr -a vi 'nvim'
abbr -a vim 'nvim'

set -g fish_key_bindings fish_vi_key_bindings

set -gx EDITOR nvim
set -gx VISUAL nvim

fzf --fish | source
zoxide init fish | source
