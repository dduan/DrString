import ArgumentParser
import Models

extension Configuration.FirstKeywordLetterCasing: ExpressibleByArgument {}
extension Section: ExpressibleByArgument {}
extension ParameterStyle: ExpressibleByArgument {}

struct SharedCommandLineOptions: ParsableArguments {
    @Option(help: "Path to the configuration TOML file. Optional path.")
    var configFile: String?

    @Option(name: [.short, .long], help: "Paths included for DrString to operate on. Repeatable path.")
    var include: [String]

    @Option(name: [.customShort("x"), .long], help: "Paths excluded for DrString to operate on. Repeatable, optional path.")
    var exclude: [String]

    @Option(help: "Whether it's ok to not have docstring for what a function/method throws. Optional (true|false). Default to `false`.")
    var ignoreThrows: Bool?

    @Option(help: "Whether it's ok to not have docstring for what a function/method returns. Optional (true|false). Default to `true`.")
    var ignoreReturns: Bool?

    @Option(help: "Casing for first letter in keywords such as `Throws`, `Returns`, `Parameter(s)`. Optional (uppercase|lowercase). Default to `uppercase`.")
    var firstLetter: Configuration.FirstKeywordLetterCasing?

    @Option(help: "Sections of docstring that requires separation to the next section. Repeatable, optional (description|parameters|throws).,")
    var needsSeparation: [Section]

    @Option(help: "Whether to require descriptions of different parameters to all start on the same column. Optional (true|false). Default to `false`.")
    var verticalAlign: Bool?

    @Option(help: "The format used to organize entries of multiple parameters. Optional (grouped|separate|whatever). Defaults to `whatever`.")
    var parameterStyle: ParameterStyle?

    @Option(help: "Consecutive lines of description should align after `:`. Repeatable, optional (parameters|throws|returns).")
    var alignAfterColon: [Section]
}

struct Main: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "drstring",
        abstract: "A Swift docstring linter, formatter, nitpicky assistant...",
        discussion: """
        DrString helps you locate and fix docstring problems such as missing
        documentation or whitespace errors. It help your team to write consistent
        docstrings.

        Learn more at: https://github.com/dduan/DrString

        EXAMPLES:

          Check every Swift source under ./Sources for problems:

            drstring check -i "Sources/**/*.swift"

          Explain the problem associated with ID `E007`:

            drstring explain E007

          Automatically fix formatting issues according to a config file:

            drstring format --config-file path/to/.drstring.toml
        """,
        subcommands: [
            Check.self,
            Explain.self,
            Format.self,
            Version.self,
        ]
    )
}

struct Version: ParsableCommand {
    static var configuration = CommandConfiguration(abstract: "Print version.")
}

extension Configuration.OutputFormat: ExpressibleByArgument {}

struct Check: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Check source files for docstring problems in given paths.",
        discussion: """
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
                --ignore-throws true \\
                --first-letter uppercase
        """
    )

    @OptionGroup()
    var options: SharedCommandLineOptions

    @Option(help: "Output format. Terminal format turns on colored text in terminals. Optional (automatic|terminal|plain|paths) default to `automatic`.")
    var format: Configuration.OutputFormat?

    @Option(help: "`true` prevents DrString from considering an excluded path superfluous. Optional (true|false). Default to `false`.")
    var superfluousExclusion: Bool?
}

struct Format: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Fix docstring formatting errors for sources in given paths.",
        discussion: """
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
    )

    @OptionGroup()
    var options: SharedCommandLineOptions

    @Option(help: "Max number of columns a line can fit, beyond which is problematic. Optional integer.")
    var columnLimit: Int?

    @Option(help: "Add placeholder for an docstring entry if it doesn't exist. Optional (true|false). Default to `false`.")
    var addPlaceholder: Bool?

    @Option(help: "First line formatting subcommand should consider affecting, 0 based. Optional number.")
    var startLine: Int?

    @Option(help: "Last line formatting subcommand should consider affecting, 0 based. Optional number.")
    var endLine: Int?
}

struct Explain: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "Explains problems (reported by the `check` command).",
        discussion: """
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
    )

    @Argument(help: "Problem ID (from `check` subcommand).")
    var problemID: [String]
}
