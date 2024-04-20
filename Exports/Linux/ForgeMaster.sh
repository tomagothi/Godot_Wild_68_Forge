#!/bin/sh
echo -ne '\033c\033]0;Godot_Wild_68_Forge\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/ForgeMaster.x86_64" "$@"
