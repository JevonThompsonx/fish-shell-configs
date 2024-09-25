function config
    if test (count $argv) -gt 0
        if test -d ~/.config/$argv[1]
            eval z ~/.config/$argv[1]
        else
            echo "Error: '$argv[1]' is not a valid directory."
            return 1
        end
    else
        # Default directory
        eval z ~/.config
    end
    # Only run nvim if the directory navigation succeeded
    nvim
end

