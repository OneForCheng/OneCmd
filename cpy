#!/usr/bin/env bash

cpy(){

    showUsage(){
        echo "usage: cpy source_file target_file"
        echo "       cpy source... [target_directory]"
        echo
        echo "       /?        Show usage."
        echo "       source    It can be a file or directory."
        echo
        echo "       It can copy multiple files or directories to the target directory."
        echo "       It will try use 'OLDPWD' variable if the target directory is not exist,"
        echo "       but it needs '.' or 'source' to run this script."
        echo
        return 0;
    }

    copyFileToTargetPath(){
        [[ ! -a "$1" ]] && echo No such file or directory: "$1" && return 1;
        [[ "$1" == "$2" ]] && echo "Not copied: $1 and $2 are identical" && return 1;
        cp -af "$1" "$2"
        return 0;
    }

    copyFiles(){
        local i
        local file
        local lastArg


        lastArg="${@:$#}"

        if [[ $# -gt 1 && -d "$lastArg" ]]; then
            for ((i=1; i<$#; i++)); do
              copyFileToTargetPath "${@:$i:1}" "$lastArg"
            done
        elif [[ -a "$lastArg" && -d "$OLDPWD" ]]; then
            for file in "$@"; do
              copyFileToTargetPath "$file" "$OLDPWD"
            done
        elif [[ $# -eq 2 && -a "$1" ]]; then
            cp -af "$1" "$2"
        else
            echo No find target directory
        fi

        return 0;
    }

    main(){
        [[ $# -eq 0 ]] && showUsage && return 1;
        [[ "$*" == *"/?"* ]] && showUsage && return 0;

        copyFiles "$@"

        return 0;
    }

    main "$@"
}

cpy "$@"
