#!/bin/bash
function auto_update
# Notify the user that the update is starting
    notify-send "System Update" "Starting system update with yay..."

# Update and upgrade system using yay
    yay -Syu --noconfirm

# Notify the user that the update is complete
    notify-send "System Update" "System update completed!"
end 