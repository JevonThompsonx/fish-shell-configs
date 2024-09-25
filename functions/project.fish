function project
    if test (count $argv) -gt 0
        if test -d ~/Documents/Projects/$argv[1]
            eval z ~/Documents/Projects/$argv[1]
        else
            echo "Error: '$argv[1]' is not a valid directory."
            return 1
        end
    else
        eval z ~/Documents/Projects
    end

    nvim
end

