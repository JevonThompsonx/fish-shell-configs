if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_greeting
    zoxide init --cmd=cd fish| source
end

# Created by `pipx` on 2024-08-02 00:44:13
set PATH $PATH /home/jevonx/.local/bin

# Created by `pipx` on 2024-08-26 02:42:09
set PATH $PATH /home/jevon/.local/bin
# cargo path
set -x PATH $PATH $HOME/.cargo/bin

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

fish_add_path /home/jevonx/.spicetify
