function project

# Explanaition: 
  # 1. Uses fzf to select from the project folder all the folders currently downloaded and select one of those options or go to the project root folder
  # 2. Opens neovim in selected folder
  
  # Command: 
    set -l project_home ~/Documents/Projects
    set -l install_supported 1

    # Check for fzf installation
    if not command -v fzf >/dev/null
        echo "Error: fzf (fuzzy finder) is required but not installed."
        
        # Detect package manager
        set -l pkg_manager
        set -l install_cmd
        
        if command -v apt >/dev/null
            set pkg_manager "APT (Debian/Ubuntu)"
            set install_cmd "sudo apt update && sudo apt install -y fzf"
        else if command -v brew >/dev/null
            set pkg_manager "Homebrew (macOS)"
            set install_cmd "brew install fzf"
        else if command -v dnf >/dev/null
            set pkg_manager "DNF (Fedora)"
            set install_cmd "sudo dnf install -y fzf"
        else if command -v pacman >/dev/null
            set pkg_manager "Pacman (Arch)"
            set install_cmd "sudo pacman -Sy fzf"
        else if command -v zypper >/dev/null
            set pkg_manager "Zypper (openSUSE)"
            set install_cmd "sudo zypper install -y fzf"
        else if command -v apk >/dev/null
            set pkg_manager "APK (Alpine)"
            set install_cmd "sudo apk add fzf"
        else if command -v nix-env >/dev/null
            set pkg_manager "Nix"
            set install_cmd "nix-env -iA nixpkgs.fzf"
        else if command -v conda >/dev/null
            set pkg_manager "Conda"
            set install_cmd "conda install -c conda-forge fzf"
        else
            set install_supported 0
            echo "Automatic installation not supported for your package manager."
            echo "Please install fzf manually: https://github.com/junegunn/fzf#installation"
        end

        if test $install_supported -eq 1
            read -P "Would you like to install fzf using $pkg_manager? [Y/n] " -l confirm
            if test "$confirm" = "" -o "$confirm" = "Y" -o "$confirm" = "y"
                echo "Installing fzf..."
                if eval $install_cmd
                    echo "fzf installed successfully!"
                else
                    echo "Installation failed. Please install manually."
                    return 1
                end
            else
                echo "Aborting: fzf is required for this script."
                return 1
            end
        else
            return 1
        end
    end

    # Rest of your original function
    if test (count $argv) -gt 0
        if test -d "$project_home/$argv[1]"
            eval z "$project_home/$argv[1]"
        else
            echo "Error: '$argv[1]' is not a valid directory."
            return 1
        end
    else
        set -l dirs "Projects Root"
        set -a dirs (command find "$project_home" -maxdepth 1 -mindepth 1 -type d -exec basename {} \; | sort)

        set -l selected_dir
        if command -v fzf >/dev/null
            set selected_dir (printf "%s\n" $dirs | fzf --prompt="Select a project: ")
        else
            # Fallback if somehow fzf isn't available after installation
            echo "Available projects:"
            for i in (seq (count $dirs))
                echo "["(printf "%2d" $i)"] $dirs[$i]"
            end
            
            while read -P "Select number (1-"(count $dirs)") or 'q' to quit: " choice
                set choice (string trim -- $choice)
                if test "$choice" = "q"
                    return 1
                else if string match -qr '^[0-9]+$' -- $choice
                    set choice (math $choice)
                    if test $choice -ge 1 -a $choice -le (count $dirs)
                        set selected_dir $dirs[$choice]
                        break
                    end
                end
                echo "Invalid selection!"
            end
        end

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
