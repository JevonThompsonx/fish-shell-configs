#!/bin/bash

# Detect terminal
if [ "$TERM" = "xterm-kitty" ]; then
  # Using kitty terminal
  fastfetch --config ~/.config/fastfetch/kitty.jsonc 
elif [ "$TERM" = "foot" ]; then
  # Using foot terminal
  fastfetch --config ~/.config/fastfetch/foot.jsonc 
else
  fastfetch --config ~/.config/fastfetch/config.jsonc 
fi
