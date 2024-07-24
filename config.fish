if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_greeting
    zoxide init --cmd=cd fish| source
end
