if status is-interactive
# Commands to run in interactive sessions can go here
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

abbr -a l eza -alh --icons
abbr -a la eza -alh --icons
abbr -a ll eza -alh --icons
abbr -a ls eza -a

abbr -a vi nvim
abbr -a vim nvim

set -g fish_key_bindings fish_vi_key_bindings

set -gx EDITOR nvim
set -gx VISUAL nvim

set -gx PROTON_ENABLE_WAYLAND 1

fzf --fish | source
zoxide init fish | source
