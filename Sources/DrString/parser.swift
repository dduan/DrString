import TSCUtility
import Models

private let mainOverview = """
DrString \(version)

A Swift docstring linter, formatter, nitpicky assistant...

DrString helps you locate and fix docstring problems such as missing
documentation or whitespace errors. It help your team to write consistent
docstrings.

Learn more at: https://github.com/dduan/DrString
"""

private let mainUsage = """
SUBCOMMAND [OPTIONS]...

EXAMPLES:

  Check every Swift source under ./Sources for problems:

    drstring check -i "Sources/**/*.swift"

  Explain the problem associated with ID `E007`:

    drstring explain E007

  Automatically fix formatting issues according to a config file:

    drstring format --config-file path/to/.drstring.toml
"""

private let checkOverview = """
Check (lint) source files for docstring problems in given paths.
"""

private let checkUsage = """
[OPTIONS]...

Paths are specfied using the `-i/--include` option, they can be repeated.
Globstar is supported (see example).

Flags can be used to specify preferred styles for docstrings.

A configuration file can be used instead of command line options to specify
preferred styles. The options are equivalent in both methods. If an option is
present in both places, command line takes priority.

EXAMPLES:
  Examine all Swift files under `./Sources` recursively:

    drstring check -i 'Sources/**/*.swift'

  Use full name for `-i` (include), exclude some paths from being checked,
  ignore throws, require first letter of keywords (e.g. `throws`, `returns`,
  etc) to be uppercase:

    drstring check \\
        --include 'Sources/**/*.swift' \\
        --include 'Tests/**/*.swift' \\
        --exclude 'Tests/Fixtures/*.swift' \\
        --ignore-throws \\
        --first-letter uppercase
"""

private let formatOverview = """
Fix docstring formatting errors for sources in given paths.
"""

private let formatUsage = """
[OPTIONS]...

Paths are specfied using the `-i/--include` option, they can be repeated.
Globstar is supported (see example).

Flags can be used to specify preferred styles for docstrings.

A configuration file can be used instead of command line options to specify
preferred styles. The options are equivalent in both methods.

EXAMPLES:

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

let explainOverview = "Explains problems (reported by the `check` command)."
let explainUsage = """
PROBLEM_ID [PROBLEM_ID]...

`check` reports each problem with an ID that looks like `E002`. This command
takes these IDs as input and prints out an explaination for each given ID.

You can specify multiple IDs as arguments.

IDs doesn't have to be fully spelled out. Alternative to `E002`, all of the
following are equivalent: `E2`, `e2`, `002`, `2`.

EXAMPLES:

Let's say you want to read out about E002, E011, and E005. All of the following
are equivalent:

  drstring explain E002 E011 E005
  drstring explain E2 E11 E5
  drstring explain 2 11 5
"""

let versionOverview = "Print version."
let helpOverview = "Print help."

let (kArgParser, kArgBinder): (ArgumentParser, ArgumentBinder<Command>) = {
    let binder = ArgumentBinder<Command>()
    let main = ArgumentParser(usage: mainUsage, overview: mainOverview)
    let check = main.add(subparser: "check", usage: checkUsage, overview: checkOverview)
    let format = main.add(subparser: "format", usage: formatUsage, overview: formatOverview)
    let explain = main.add(subparser: "explain", usage: explainUsage, overview: explainOverview)
    _ = main.add(subparser: "version", usage: "", overview: versionOverview)
    _ = main.add(subparser: "help", usage: "", overview: helpOverview)

    binder.bind(parser: main) { command, subcommand in
        switch subcommand {
        case "check":
            command = .check(configFile: nil, config: command.config ?? Configuration())
        case "format":
            command = .format(command.config ?? Configuration())
        case "version":
            command = .version
        default:
            command = .help
        }
    }

    for parser in [check, format] {
        binder.bind(
            option: parser.add(
                option: "--config-file",
                shortName: nil,
                kind: String.self,
                usage: "Path to the configuration TOML file. Optional path."
            )
        ) { $0.configFile = $1 }

        binder.bind(
            option: parser.add(
                option: "--ignore-throws",
                shortName: nil,
                kind: Bool.self,
                usage: "Whether it's ok to not have docstring for what a function/method returns. Optional (true|false). Default to `true`."
            )
        ) { $0.config?.ignoreDocstringForThrows = $1 }

        binder.bind(
            option: parser.add(
                option: "--ignore-returns",
                shortName: nil,
                kind: Bool.self,
                usage: "Whether it's ok to not have docstring for what a function/method throws. Optional (true|false), default to `false`."
            )
        ) { $0.config?.ignoreDocstringForReturns = $1 }

        binder.bind(
            option: parser.add(
                option: "--include",
                shortName: "-i",
                kind: [String].self,
                strategy: .oneByOne,
                usage: "Paths included for DrString to operate on. Repeatable path."
            )
        ) { $0.config?.includedPaths = $1 }

        binder.bind(
            option: parser.add(
                option: "--exclude",
                shortName: "-x",
                kind: [String].self,
                strategy: .oneByOne,
                usage: "Paths excluded for DrString to operate on. Repeatable, optional path."
            )
        ) { $0.config?.excludedPaths = $1 }

        binder.bind(
            option: parser.add(
                option: "--format",
                shortName: nil,
                kind: Configuration.OutputFormat.self,
                usage: "Output format. Terminal format turns on colored text in terminals. Optional (automatic|terminal|plain|paths) default to `automatic`."
            )
        ) { $0.config?.outputFormat = $1 }

        binder.bind(
            option: parser.add(
                option: "--first-letter",
                shortName: nil,
                kind: Configuration.FirstKeywordLetterCasing.self,
                usage: "Casing for first letter in keywords such as `Throws`, `Returns`, `Parameter(s)`. Optional (uppercase, lowercase). Default to `uppercase`."
            )
        ) { $0.config?.firstKeywordLetter = $1 }

        binder.bind(
            option: parser.add(
                option: "--parameter-style",
                shortName: nil,
                kind: ParameterStyle.self,
                usage: "The format used to organize entries of multiple parameters. Optional (grouped|separate|whatever). Defaults to `whatever`."
            )
        ) { $0.config?.parameterStyle = $1 }

        binder.bind(
            option: parser.add(
                option: "--needs-separation",
                shortName: nil,
                kind: [Section].self,
                usage: "Sections of docstring that requires separation to the next section. Repeatable, optional (description|parameters|throws).,"
            )
        ) { $0.config?.separatedSections = $1 }

        binder.bind(
            option: parser.add(
                option: "--vertical-align",
                shortName: nil,
                kind: Bool.self,
                usage: "Whether to require descriptions of different parameters to all start on the same column. Optional (true|false). Default to `false`."
            )
        ) { $0.config?.verticalAlignParameterDescription = $1 }

        binder.bind(
            option: parser.add(
                option: "--superfluous-exclusion",
                shortName: nil,
                kind: Bool.self,
                usage: "`true` prevents DrString from considering an excluded path superfluous. Optional (true|false). Default to `false`."
            )
        ) { $0.config?.allowSuperfluousExclusion = $1 }

        binder.bind(
            option: parser.add(
                option: "--align-after-colon",
                shortName: nil,
                kind: [Section].self,
                strategy: .oneByOne,
                usage: "Consecutive lines of description should align after `:`. Repeatable, optional (parameters|throws|returns)."
            )
        ) { $0.config?.alignAfterColon = $1 }

        binder.bind(
            option: parser.add(
                option: "--column-limit",
                shortName: nil,
                kind: Int.self,
                usage: "Max number of columns a line can fit, beyond which is problematic. Optional integer."
            )
        ) { $0.config?.columnLimit = $1 }
    }

    binder.bind(
        option: format.add(
            option: "--add-placeholder",
            shortName: nil,
            kind: Bool.self,
            usage: "Add placeholder for an docstring entry if it doesn't exist. Optional (true|false). Default to `false`."
        )
    ) { $0.config?.addPlaceholder = $1 }

    binder.bind(
        option: format.add(
            option: "--start-line",
            shortName: nil,
            kind: Int.self,
            usage: "First line formatting subcommand should consider affecting, 0 based. Optional number."
        )
    ) { $0.config?.startLine = $1 }

    binder.bind(
        option: format.add(
            option: "--end-line",
            shortName: nil,
            kind: Int.self,
            usage: "Last line formatting subcommand should consider affecting, 0 based. Optional number."
        )
    ) { $0.config?.endLine = $1 }

    binder.bind(
        positional: explain.add(
            positional: "problem-id",
            kind: [String].self,
            optional: false,
            strategy: .remaining,
            usage: "Problem ID (from `check` subcommand)."
        )
    ) { $0 = .explain($1) }


    return (main, binder)
}()
