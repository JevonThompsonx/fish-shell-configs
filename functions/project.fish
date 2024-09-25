function project 

# Check if an argument is provided
if test (count $argv) -gt 0
    # If the argument is a valid directory, change to it
    if test -d $argv[1]
        cd ~/Documents/Projects/$argv[1]
    else
        echo "Error: '$argv[1]' is not a valid directory."
    end
else
    # Default directory
    cd ~/Documents/Projects
end
  nvim
end
