#!/bin/bash

filter_exts=("js" "scss" "json" "html" "htm")
src_path=/codes/web-commons
dest_path=/codes/bmb-organizer/node_modules/web-commons

mod_file="$1"
dest_file=${mod_file/"$src_path"/"$dest_path"}

ext="${mod_file##*.}"

ele_in() {
    local e
    for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
    return 1
}

if (ele_in "$ext" "${filter_exts[@]}") && [ -f "$mod_file" ]; then
    echo cp -f "$mod_file" "$dest_file"
fi

