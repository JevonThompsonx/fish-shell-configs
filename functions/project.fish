function project
    set -l project_home ~/Documents/Projects

    # Handle arguments if provided
    if test (count $argv) -gt 0
        if test -d "$project_home/$argv[1]"
            eval z "$project_home/$argv[1]"
        else
            echo "Error: '$argv[1]' is not a valid directory."
            return 1
        end
    else
        # Collect directories (Project Root first, then sorted subdirectories)
        set -l dirs "Projects Root"
        set -a dirs (command find "$project_home" -maxdepth 1 -mindepth 1 -type d -exec basename {} \; | sort)

        # Interactive selection
        set -l selected_dir
        if command -v fzf >/dev/null
            set selected_dir (printf "%s\n" $dirs | fzf --prompt="Select a project: ")
        else
            # Fallback to numbered list
            echo "Available projects:"
            for i in (seq (count $dirs))
                echo "["(printf "%2d" $i)"] $dirs[$i]"
            end
            
            while read -P "Select number (1-"(count $dirs)") or 'q' to quit: " choice
                set choice (string trim -- $choice)
                if test "$choice" = "q"
                    return 1
                else if string match -qr '^[0-9]+$' -- $choice
                    set choice (math $choice) # Convert to number
                    if test $choice -ge 1 -a $choice -le (count $dirs)
                        set selected_dir $dirs[$choice]
                        break
                    end
                end
                echo "Invalid selection!"
            end
        end

        # Handle selection
        if test -z "$selected_dir"
            echo "No selection made."
            return 1
        end

        if test "$selected_dir" = "Projects Root"
            eval z "$project_home"
        else
            eval z "$project_home/$selected_dir"
        end
    end

    nvim
end
