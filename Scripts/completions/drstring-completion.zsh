#compdef drstring
local context state state_descr line
_drstring_commandname=$words[1]
typeset -A opt_args

_drstring() {
    integer ret=1
    local -a args
    args+=(
        '(-h --help)'{-h,--help}'[Print help information.]'
        '(-): :->command'
        '(-)*:: :->arg'
    )
    _arguments -w -s -S $args[@] && ret=0
    case $state in
        (command)
            local subcommands
            subcommands=(
                'check:Check source files for docstring problems in given paths.'
                'explain:Explains problems (reported by the `check` command).'
                'format:Fix docstring formatting errors for sources in given paths.'
                'help:Show subcommand help information.'
            )
            _describe "subcommand" subcommands
            ;;
        (arg)
            case ${words[1]} in
                (check)
                    _drstring_check
                    ;;
                (explain)
                    _drstring_explain
                    ;;
                (format)
                    _drstring_format
                    ;;
                (help)
                    _drstring_help
                    ;;
            esac
            ;;
    esac

    return ret
}

_drstring_check() {
    integer ret=1
    local -a args
    args+=(
        '--config-file[Path to the configuration TOML file. Optional path.]:path:'
        '(-i --include)'{-i,--include}'[Paths included for DrString to operate on. Repeatable path.]:path:'
        '(-x --exclude)'{-x,--exclude}'[Paths excluded for DrString to operate on. Repeatable, optional path.]:path:'
        '--no-exclude[Override `exclude` so that its value is empty.]'
        '--ignore-throws[Whether it'"'"'s ok to not have docstring for what a function/method throws. Optional. Default to '"'"'yes'"'"'.]'
        '--no-ignore-throws'
        '--ignore-returns[Whether it'"'"'s ok to not have docstring for what a function/method returns. Optional. Default to '"'"'no'"'"'.]'
        '--no-ignore-returns'
        '--first-letter[Casing for first letter in keywords such as `Throws`, `Returns`, `Parameter(s)`. Optional (uppercase|lowercase). Default to '"'"'uppercase'"'"'.]:casing:'
        '--needs-separation[Sections of docstring that requires separation to the next section. Repeatable, optional (description|parameters|throws).]:section:(description parameters throws returns)'
        '--no-needs-separation[Override `needs-separation` so that none is empty.]'
        '--vertical-align[Whether to require descriptions of different parameters to all start on the same column. Optional. Default to '"'"'no'"'"'.]'
        '--no-vertical-align'
        '--parameter-style[The format used to organize entries of multiple parameters. Optional (grouped|separate|whatever). Defaults to `whatever`.]:style:'
        '--align-after-colon[Consecutive lines of description should align after `:`. Repeatable, optional (parameters|throws|returns).]:section:(description parameters throws returns)'
        '--no-align-after-colon[Override `align-after-colon` so that none is empty.]'
        '--format[Output format. Terminal format turns on colored text in terminals. Optional (automatic|terminal|plain|paths). Default to `automatic`.]:format:'
        '--superfluous-exclusion['"'"'yes'"'"' prevents DrString from considering an explicitly excluded path superfluous. Optional. Default to `no`.]'
        '--no-superfluous-exclusion'
        '--empty-patterns['"'"'yes'"'"' prevents DrString from considering a pattern for inclusion or exlusion invalid when the pattern matches no file paths. Optional. Default to `no`.]'
        '--no-empty-patterns'
        '(-h --help)'{-h,--help}'[Print help information.]'
    )
    _arguments -w -s -S $args[@] && ret=0

    return ret
}

_drstring_explain() {
    integer ret=1
    local -a args
    args+=(
        ':problem-id:'
        '(-h --help)'{-h,--help}'[Print help information.]'
    )
    _arguments -w -s -S $args[@] && ret=0

    return ret
}

_drstring_format() {
    integer ret=1
    local -a args
    args+=(
        '--config-file[Path to the configuration TOML file. Optional path.]:path:'
        '(-i --include)'{-i,--include}'[Paths included for DrString to operate on. Repeatable path.]:path:'
        '(-x --exclude)'{-x,--exclude}'[Paths excluded for DrString to operate on. Repeatable, optional path.]:path:'
        '--no-exclude[Override `exclude` so that its value is empty.]'
        '--ignore-throws[Whether it'"'"'s ok to not have docstring for what a function/method throws. Optional. Default to '"'"'yes'"'"'.]'
        '--no-ignore-throws'
        '--ignore-returns[Whether it'"'"'s ok to not have docstring for what a function/method returns. Optional. Default to '"'"'no'"'"'.]'
        '--no-ignore-returns'
        '--first-letter[Casing for first letter in keywords such as `Throws`, `Returns`, `Parameter(s)`. Optional (uppercase|lowercase). Default to '"'"'uppercase'"'"'.]:casing:'
        '--needs-separation[Sections of docstring that requires separation to the next section. Repeatable, optional (description|parameters|throws).]:section:(description parameters throws returns)'
        '--no-needs-separation[Override `needs-separation` so that none is empty.]'
        '--vertical-align[Whether to require descriptions of different parameters to all start on the same column. Optional. Default to '"'"'no'"'"'.]'
        '--no-vertical-align'
        '--parameter-style[The format used to organize entries of multiple parameters. Optional (grouped|separate|whatever). Defaults to `whatever`.]:style:'
        '--align-after-colon[Consecutive lines of description should align after `:`. Repeatable, optional (parameters|throws|returns).]:section:(description parameters throws returns)'
        '--no-align-after-colon[Override `align-after-colon` so that none is empty.]'
        '--column-limit[Max number of columns a line can fit, beyond which is problematic. Optional integer.]:column:'
        '--add-placeholder[Add placeholder for an docstring entry if it doesn'"'"'t exist. Optional. Default to '"'"'no'"'"'.]'
        '--no-add-placeholder'
        '--start-line[First line formatting subcommand should consider affecting, 0 based. Optional number.]:line:'
        '--end-line[Last line formatting subcommand should consider affecting, 0 based. Optional number.]:line:'
        '(-h --help)'{-h,--help}'[Print help information.]'
    )
    _arguments -w -s -S $args[@] && ret=0

    return ret
}

_drstring_help() {
    integer ret=1
    local -a args
    args+=(
        ':subcommands:'
        '(-h --help)'{-h,--help}'[Print help information.]'
    )
    _arguments -w -s -S $args[@] && ret=0

    return ret
}


_custom_completion() {
    local completions=("${(@f)$($*)}")
    _describe '' completions
}

_drstring
