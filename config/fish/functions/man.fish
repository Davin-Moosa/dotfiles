function cd_dots
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
