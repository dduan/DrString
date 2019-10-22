import DrString
import Guaka
import Pathos
import TOMLDecoder

private let checkFlags = [
    Options.ignoreThrows,
    Options.ignoreReturns,
    Options.include,
    Options.exclude,
    Options.format,
    Options.firstLetter,
    Options.parameterStyle,
    Options.separations,
    Options.verticalAlign,
    Options.superfluousExclusion,
]

func check(flags: Flags, arguments: [String], help: String) {
    let config: DrString.Configuration
    let path = ".drstring.toml"
    if (try? isA(.file, atPath: path)) == .some(true) {
        guard let configText = try? readString(atPath: path),
            let decoded = try? TOMLDecoder().decode(DrString.Configuration.self, from: configText) else
        {
            fputs("Tried to run `check`, but \(path) doesn't contain a valid config file.\n", stderr)
            fputs(help, stderr)
            exit(EXIT_FAILURE)
        }

        config = decoded
    } else {
        config = DrString.Configuration(flags)
    }

    switch check(with: config, configFile: path) {
    case .ok:
        return
    case .foundProblems:
        exit(EXIT_FAILURE)
    case .missingInput:
        fputs(help, stderr)
        exit(EXIT_FAILURE)
    }
}

private let longMessage = """
Check (lint) source files for docsttring problems in given paths.

Paths are specfied using the `-i/--include` option, they can be repeated.
Globstar is supported (see example).

Flags can be used to specify preferred styles for docstrings.

A configuration file can be used instead of command line options to specify
preferred styles. The options are equivalent in both methods. When a valid
configuration file is present, The root command `drstring` directly works the
same way as this subcommand.
"""

private let example = """
  Examine all Swift files under `./Sources` recursively:

    drstring check -i 'Sources/**/*.swift'

  Use full name for `-i` (include), exclude some paths from being checked,
  ignore throws, require first letter of keywords (e.g. `throws`, `returns`,
  etc) to be uppercase:

    drstring check \\
        --include 'Sources/**/*.swift' \\
        --include 'Tests/**/*.swift' \\
        --exclude 'Tests/Fixtures/*.swift' \\
        --ignore-throws true \\
        --first-letter uppercase
"""

let checkCommand: Guaka.Command = {
    var command = Guaka.Command(
        usage: "check [-i PATTERN]...",
        shortMessage: "Check problems for existing doc strings",
        longMessage: longMessage,
        flags: checkFlags,
        example: example,
        aliases: ["lint", "c", "l"])

    command.run = { flags, arguments in
        check(flags: flags, arguments: arguments, help: command.helpMessage)
    }

    return command
}()
