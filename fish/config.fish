if status is-interactive
    # Commands to run in interactive sessions can go here
end

### Functions

function pg_connect
    set -l pg_name
    set -l pg_pass
    set -l pg_port
    set -l pg_user

    while true
        if not read -P "Enter PostgreSQL database name: " pg_name
            return
        end

        if test -n "$pg_name"
            break
        end

        echo "Database name cannot be empty."
    end

    while true
        if not read -P "Enter PostgreSQL database password: " pg_pass
            return
        end

        if test -n "$pg_pass"
            break
        end

        echo "Database password cannot be empty."
    end

    if not read -P "Enter port (default: 5432): " pg_port
        return
    end

    if not read -P "Enter user: " pg_user
        return
    end

    if test -z "$pg_port"
        set pg_port 5432
    end

    PGPASSWORD="$pg_pass" psql -U "$pg_user" \
        -h 0.0.0.0 \
        -p "$pg_port" \
        "$pg_name"
end

function fcd
    set search_paths ~/ ~/documents ~/development
    set selection (find $search_paths -mindepth 1 -maxdepth 1 -type d | fzf)
    
    if test -n "$selection"
        cd "$selection"
    end
end

function y
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end

function tm
    tmux attach 2>/dev/null; and return
    tmux new
end

### Aliases

alias v="nvim"
alias hx="helix"
alias ls="eza"
alias mirrors="sudo $HOME/.config/_scripts/mirrors.sh"
alias pnpx="pnpm dlx"

set -gx EDITOR nvim
set -gx ANDROID_HOME $HOME/Android/Sdk
set -gx NDK_HOME /opt/android-ndk
set -gx CAPACITOR_ANDROID_STUDIO_PATH /usr/bin/android-studio
set -gx JAVA_HOME /opt/android-studio/jbr

### Keybinds

bind \cf "~/.config/_scripts/tmux-sessionizer.sh"
bind alt-tab accept-autosuggestion
bind \cx "clear; commandline -f repaint"

### Others

set fish_greeting
starship init fish | source

# zoxide init fish | source

set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
set --export PATH "$HOME/go/bin" $PATH
set --export PATH "/opt/lampp" $PATH
set --export ENTE_CLI_SECRETS_PATH "$HOME/.ente-secrets.txt"

source "$HOME/.cargo/env.fish"  # For fish
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
