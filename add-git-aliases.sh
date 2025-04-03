#!/bin/bash

# List of aliases in "name=command" format
ALIASES=(
    "ll=ls -la"
    "gs=git status"
    "gp=git push"
    "gd=git diff"
    "gco=git checkout"
    "g=git"
    "gpm=git checkout main && git pull"
)

# Detect shell and config file
detect_shell_and_config() {
    local shell_name=$(basename "$SHELL")
    local config_file=""

    case "$shell_name" in
        bash)
            config_file="$HOME/.bashrc"
            ;;
        zsh)
            config_file="$HOME/.zshrc"
            ;;
        fish)
            config_file="$HOME/.config/fish/config.fish"
            ;;
        *)
            echo "Unsupported shell: $shell_name"
            exit 1
            ;;
    esac

    echo "$config_file"
}

# Append alias if not present
add_alias_if_needed() {
    local name="$1"
    local command="$2"
    local config_file="$3"
    local shell_name=$(basename "$SHELL")

    if [[ "$shell_name" == "fish" ]]; then
        alias_string="alias $name \"$command\""
    else
        alias_string="alias $name=\"$command\""
    fi

    if grep -Fq "$alias_string" "$config_file"; then
        echo "Alias '$name' already exists in $config_file"
    else
        echo "$alias_string" >> "$config_file"
        echo "Added alias '$name' to $config_file"
    fi
}

main() {
    config_file=$(detect_shell_and_config)

    for alias in "${ALIASES[@]}"; do
        name="${alias%%=*}"
        command="${alias#*=}"
        add_alias_if_needed "$name" "$command" "$config_file"
    done
}

main
