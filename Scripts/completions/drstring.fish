function _swift_drstring_using_command
    set -l cmd (commandline -opc)
    if [ (count $cmd) -eq (count $argv) ]
        for i in (seq (count $argv))
            if [ $cmd[$i] != $argv[$i] ]
                return 1
            end
        end
        return 0
    end
    return 1
end
complete -c drstring -n '_swift_drstring_using_command drstring' -f -l version -d 'Show the version.'
complete -c drstring -n '_swift_drstring_using_command drstring' -f -s h -l help -d 'Show help information.'
complete -c drstring -n '_swift_drstring_using_command drstring' -f -a 'check' -d 'Check source files for docstring problems in given paths.'
complete -c drstring -n '_swift_drstring_using_command drstring' -f -a 'explain' -d 'Explains problems (reported by the `check` command).'
complete -c drstring -n '_swift_drstring_using_command drstring' -f -a 'format' -d 'Fix docstring formatting errors for sources in given paths.'
complete -c drstring -n '_swift_drstring_using_command drstring' -f -a 'extract' -d 'Extract existing docstrings and print out as JSON.'
complete -c drstring -n '_swift_drstring_using_command drstring' -f -a 'help' -d 'Show subcommand help information.'
complete -c drstring -n '_swift_drstring_using_command drstring check' -f -r -l config-file -d 'Path to the configuration TOML file. Optional path.'
complete -c drstring -n '_swift_drstring_using_command drstring check' -f -r -s i -l include -d 'Paths included for DrString to operate on. Repeatable path.'
complete -c drstring -n '_swift_drstring_using_command drstring check' -f -r -s x -l exclude -d 'Paths excluded for DrString to operate on. Repeatable, optional path.'
complete -c drstring -n '_swift_drstring_using_command drstring check' -f -l no-exclude -d 'Override `exclude` so that its value is empty.'
complete -c drstring -n '_swift_drstring_using_command drstring check' -f -l ignore-throws -d 'Whether it\'s ok to not have docstring for what a function/method throws. Optional. Default to \'yes\'.'
complete -c drstring -n '_swift_drstring_using_command drstring check' -f -l no-ignore-throws -d 'Whether it\'s ok to not have docstring for what a function/method throws. Optional. Default to \'yes\'.'
complete -c drstring -n '_swift_drstring_using_command drstring check' -f -l ignore-returns -d 'Whether it\'s ok to not have docstring for what a function/method returns. Optional. Default to \'no\'.'
complete -c drstring -n '_swift_drstring_using_command drstring check' -f -l no-ignore-returns -d 'Whether it\'s ok to not have docstring for what a function/method returns. Optional. Default to \'no\'.'
complete -c drstring -n '_swift_drstring_using_command drstring check' -f -r -l first-letter -d 'Casing for first letter in keywords such as `Throws`, `Returns`, `Parameter(s)`. Optional (uppercase|lowercase). Default to \'uppercase\'.'
complete -c drstring -n '_swift_drstring_using_command drstring check' -f -r -l needs-separation -d 'Sections of docstring that requires separation to the next section. Repeatable, optional (description|parameters|throws).'
complete -c drstring -n '_swift_drstring_using_command drstring check --needs-separation' -f -k -a 'description parameters throws returns'
complete -c drstring -n '_swift_drstring_using_command drstring check' -f -l no-needs-separation -d 'Override `needs-separation` so that none is empty.'
complete -c drstring -n '_swift_drstring_using_command drstring check' -f -l vertical-align -d 'Whether to require descriptions of different parameters to all start on the same column. Optional. Default to \'no\'.'
complete -c drstring -n '_swift_drstring_using_command drstring check' -f -l no-vertical-align -d 'Whether to require descriptions of different parameters to all start on the same column. Optional. Default to \'no\'.'
complete -c drstring -n '_swift_drstring_using_command drstring check' -f -r -l parameter-style -d 'The format used to organize entries of multiple parameters. Optional (grouped|separate|whatever). Defaults to `whatever`.'
complete -c drstring -n '_swift_drstring_using_command drstring check' -f -r -l align-after-colon -d 'Consecutive lines of description should align after `:`. Repeatable, optional (parameters|throws|returns).'
complete -c drstring -n '_swift_drstring_using_command drstring check --align-after-colon' -f -k -a 'description parameters throws returns'
complete -c drstring -n '_swift_drstring_using_command drstring check' -f -l no-align-after-colon -d 'Override `align-after-colon` so that none is empty.'
complete -c drstring -n '_swift_drstring_using_command drstring check' -f -r -l format -d 'Output format. Terminal format turns on colored text in terminals. Optional (automatic|terminal|plain|paths). Default to `automatic`.'
complete -c drstring -n '_swift_drstring_using_command drstring check' -f -l superfluous-exclusion -d '\'yes\' prevents DrString from considering an explicitly excluded path superfluous. Optional. Default to `no`.'
complete -c drstring -n '_swift_drstring_using_command drstring check' -f -l no-superfluous-exclusion -d '\'yes\' prevents DrString from considering an explicitly excluded path superfluous. Optional. Default to `no`.'
complete -c drstring -n '_swift_drstring_using_command drstring check' -f -l empty-patterns -d '\'yes\' prevents DrString from considering a pattern for inclusion or exlusion invalid when the pattern matches no file paths. Optional. Default to `no`.'
complete -c drstring -n '_swift_drstring_using_command drstring check' -f -l no-empty-patterns -d '\'yes\' prevents DrString from considering a pattern for inclusion or exlusion invalid when the pattern matches no file paths. Optional. Default to `no`.'
complete -c drstring -n '_swift_drstring_using_command drstring check' -f -s h -l help -d 'Show help information.'
complete -c drstring -n '_swift_drstring_using_command drstring explain' -f -s h -l help -d 'Show help information.'
complete -c drstring -n '_swift_drstring_using_command drstring format' -f -r -l config-file -d 'Path to the configuration TOML file. Optional path.'
complete -c drstring -n '_swift_drstring_using_command drstring format' -f -r -s i -l include -d 'Paths included for DrString to operate on. Repeatable path.'
complete -c drstring -n '_swift_drstring_using_command drstring format' -f -r -s x -l exclude -d 'Paths excluded for DrString to operate on. Repeatable, optional path.'
complete -c drstring -n '_swift_drstring_using_command drstring format' -f -l no-exclude -d 'Override `exclude` so that its value is empty.'
complete -c drstring -n '_swift_drstring_using_command drstring format' -f -l ignore-throws -d 'Whether it\'s ok to not have docstring for what a function/method throws. Optional. Default to \'yes\'.'
complete -c drstring -n '_swift_drstring_using_command drstring format' -f -l no-ignore-throws -d 'Whether it\'s ok to not have docstring for what a function/method throws. Optional. Default to \'yes\'.'
complete -c drstring -n '_swift_drstring_using_command drstring format' -f -l ignore-returns -d 'Whether it\'s ok to not have docstring for what a function/method returns. Optional. Default to \'no\'.'
complete -c drstring -n '_swift_drstring_using_command drstring format' -f -l no-ignore-returns -d 'Whether it\'s ok to not have docstring for what a function/method returns. Optional. Default to \'no\'.'
complete -c drstring -n '_swift_drstring_using_command drstring format' -f -r -l first-letter -d 'Casing for first letter in keywords such as `Throws`, `Returns`, `Parameter(s)`. Optional (uppercase|lowercase). Default to \'uppercase\'.'
complete -c drstring -n '_swift_drstring_using_command drstring format' -f -r -l needs-separation -d 'Sections of docstring that requires separation to the next section. Repeatable, optional (description|parameters|throws).'
complete -c drstring -n '_swift_drstring_using_command drstring format --needs-separation' -f -k -a 'description parameters throws returns'
complete -c drstring -n '_swift_drstring_using_command drstring format' -f -l no-needs-separation -d 'Override `needs-separation` so that none is empty.'
complete -c drstring -n '_swift_drstring_using_command drstring format' -f -l vertical-align -d 'Whether to require descriptions of different parameters to all start on the same column. Optional. Default to \'no\'.'
complete -c drstring -n '_swift_drstring_using_command drstring format' -f -l no-vertical-align -d 'Whether to require descriptions of different parameters to all start on the same column. Optional. Default to \'no\'.'
complete -c drstring -n '_swift_drstring_using_command drstring format' -f -r -l parameter-style -d 'The format used to organize entries of multiple parameters. Optional (grouped|separate|whatever). Defaults to `whatever`.'
complete -c drstring -n '_swift_drstring_using_command drstring format' -f -r -l align-after-colon -d 'Consecutive lines of description should align after `:`. Repeatable, optional (parameters|throws|returns).'
complete -c drstring -n '_swift_drstring_using_command drstring format --align-after-colon' -f -k -a 'description parameters throws returns'
complete -c drstring -n '_swift_drstring_using_command drstring format' -f -l no-align-after-colon -d 'Override `align-after-colon` so that none is empty.'
complete -c drstring -n '_swift_drstring_using_command drstring format' -f -r -l column-limit -d 'Max number of columns a line can fit, beyond which is problematic. Optional integer.'
complete -c drstring -n '_swift_drstring_using_command drstring format' -f -l add-placeholder -d 'Add placeholder for an docstring entry if it doesn\'t exist. Optional. Default to \'no\'.'
complete -c drstring -n '_swift_drstring_using_command drstring format' -f -l no-add-placeholder -d 'Add placeholder for an docstring entry if it doesn\'t exist. Optional. Default to \'no\'.'
complete -c drstring -n '_swift_drstring_using_command drstring format' -f -r -l start-line -d 'First line formatting subcommand should consider affecting, 0 based. Optional number.'
complete -c drstring -n '_swift_drstring_using_command drstring format' -f -r -l end-line -d 'Last line formatting subcommand should consider affecting, 0 based. Optional number.'
complete -c drstring -n '_swift_drstring_using_command drstring format' -f -s h -l help -d 'Show help information.'
complete -c drstring -n '_swift_drstring_using_command drstring extract' -f -r -l config-file -d 'Path to the configuration TOML file. Optional path.'
complete -c drstring -n '_swift_drstring_using_command drstring extract' -f -r -s i -l include -d 'Paths included for DrString to operate on. Repeatable path.'
complete -c drstring -n '_swift_drstring_using_command drstring extract' -f -r -s x -l exclude -d 'Paths excluded for DrString to operate on. Repeatable, optional path.'
complete -c drstring -n '_swift_drstring_using_command drstring extract' -f -l no-exclude -d 'Override `exclude` so that its value is empty.'
complete -c drstring -n '_swift_drstring_using_command drstring extract' -f -s h -l help -d 'Show help information.'
