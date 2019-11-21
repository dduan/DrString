import DrString
import Editor
import Guaka

func format(with options: ParsedOptions, help: String) {
    switch options {
    case .configDecodeFailure(let path):
        fputs("Tried to run `format`, but \(path) doesn't contain a valid config file.\n", stderr)
        fputs(help, stderr)
        exit(EXIT_FAILURE)
    case .success(let config, _):
        format(with: config)
    }
}

private let formatFlags = [
    Options.include,
    Options.exclude,
    Options.firstLetter,
    Options.parameterStyle,
    Options.separations,
    Options.verticalAlign,
    Options.columnLimit,
]

private let longMessage = """
Fix docstring formatting errors for sources in given paths.

Paths are specfied using the `-i/--include` option, they can be repeated.
Globstar is supported (see example).

Flags can be used to specify preferred styles for docstrings.

A configuration file can be used instead of command line options to specify
preferred styles. The options are equivalent in both methods.
"""

private let example = """
  Fix all Swift files under `./Sources` recursively:

    drstring format -i 'Sources/**/*.swift'

  Use full name for `-i` (include), exclude some paths from being checked,
  ignore throws, require an empty docstring line after parameters, and
  continuation of descriptions to vertical align after ':'s.


    drstring format \\
        --include 'Sources/**/*.swift' \\
        --include 'Tests/**/*.swift' \\
        --exclude 'Tests/Fixtures/*.swift' \\
        --needs-separation parameters \\
        --align-after-colon parameters
"""

let formatCommand: Guaka.Command = {
    var command = Guaka.Command(
        usage: "format [-i PATTERN]...",
        shortMessage: "Fix docstring problems",
        longMessage: longMessage,
        flags: formatFlags,
        example: example,
        aliases: ["fix", "f"])
    command.run = { flags, arguments in
        let options = ParsedOptions(from: flags, arguments: arguments)
        format(with: options, help: command.helpMessage)
    }
    return command
}()
