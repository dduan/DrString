#!/bin/bash

_drstring() {
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    COMPREPLY=()
    opts="check explain format extract help -h --help"
    if [[ $COMP_CWORD == "1" ]]; then
        COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
        return
    fi
    case ${COMP_WORDS[1]} in
        (check)
            _drstring_check 2
            return
            ;;
        (explain)
            _drstring_explain 2
            return
            ;;
        (format)
            _drstring_format 2
            return
            ;;
        (extract)
            _drstring_extract 2
            return
            ;;
        (help)
            _drstring_help 2
            return
            ;;
    esac
    COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
}
_drstring_check() {
    opts="--config-file -i --include -x --exclude --no-exclude --no-exclude --ignore-throws --no-ignore-throws --ignore-returns --no-ignore-returns --first-letter --needs-separation --no-needs-separation --vertical-align --no-vertical-align --parameter-style --align-after-colon --no-align-after-colon --format --superfluous-exclusion --no-superfluous-exclusion --empty-patterns --no-empty-patterns -h --help"
    if [[ $COMP_CWORD == "$1" ]]; then
        COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
        return
    fi
    case $prev in
        --config-file)
            
            return
        ;;
        -i|--include)
            
            return
        ;;
        -x|--exclude)
            
            return
        ;;
        --first-letter)
            
            return
        ;;
        --needs-separation)
            COMPREPLY=( $(compgen -W "description parameters throws returns" -- "$cur") )
            return
        ;;
        --parameter-style)
            
            return
        ;;
        --align-after-colon)
            COMPREPLY=( $(compgen -W "description parameters throws returns" -- "$cur") )
            return
        ;;
        --format)
            
            return
        ;;
    esac
    COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
}
_drstring_explain() {
    opts="-h --help"
    if [[ $COMP_CWORD == "$1" ]]; then
        COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
        return
    fi
    COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
}
_drstring_format() {
    opts="--config-file -i --include -x --exclude --no-exclude --no-exclude --ignore-throws --no-ignore-throws --ignore-returns --no-ignore-returns --first-letter --needs-separation --no-needs-separation --vertical-align --no-vertical-align --parameter-style --align-after-colon --no-align-after-colon --column-limit --add-placeholder --no-add-placeholder --start-line --end-line -h --help"
    if [[ $COMP_CWORD == "$1" ]]; then
        COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
        return
    fi
    case $prev in
        --config-file)
            
            return
        ;;
        -i|--include)
            
            return
        ;;
        -x|--exclude)
            
            return
        ;;
        --first-letter)
            
            return
        ;;
        --needs-separation)
            COMPREPLY=( $(compgen -W "description parameters throws returns" -- "$cur") )
            return
        ;;
        --parameter-style)
            
            return
        ;;
        --align-after-colon)
            COMPREPLY=( $(compgen -W "description parameters throws returns" -- "$cur") )
            return
        ;;
        --column-limit)
            
            return
        ;;
        --start-line)
            
            return
        ;;
        --end-line)
            
            return
        ;;
    esac
    COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
}
_drstring_extract() {
    opts="--config-file -i --include -x --exclude --no-exclude -h --help"
    if [[ $COMP_CWORD == "$1" ]]; then
        COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
        return
    fi
    case $prev in
        --config-file)
            
            return
        ;;
        -i|--include)
            
            return
        ;;
        -x|--exclude)
            
            return
        ;;
    esac
    COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
}
_drstring_help() {
    opts="-h --help"
    if [[ $COMP_CWORD == "$1" ]]; then
        COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
        return
    fi
    COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
}


complete -F _drstring drstring
