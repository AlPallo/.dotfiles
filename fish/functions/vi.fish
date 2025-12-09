function vi
    if test (count $argv) -eq 0
        command vi .
    else
        command vi $argv
    end
end
