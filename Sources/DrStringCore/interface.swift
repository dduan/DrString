import ArgumentParser
import Models

extension Configuration.FirstKeywordLetterCasing: ExpressibleByArgument {}
extension Section: ExpressibleByArgument {}
extension ParameterStyle: ExpressibleByArgument {}

struct SharedCommandLineOptions: ParsableArguments {
    @Option(help: .init("Path to the configuration TOML file. Optional path.", valueName: "path"))
    var configFile: String?

    @Option(
        name: [.short, .long],
        help: .init("Paths included for DrString to operate on. Repeatable path.", valueName: "path"))
    var include: [String] = []

    @Option(
        name: [.customShort("x"), .long],
        help: .init("Paths excluded for DrString to operate on. Repeatable, optional path.", valueName: "path"))
    var exclude: [String] = []

    @Flag(help: "Override `exclude` so that its value is empty.")
    var noExclude: Bool = false

    @Flag(
        inversion: .prefixedNo,
        help: "Whether it's ok to not have docstring for what a function/method throws. Optional. Default to 'yes'.")
    var ignoreThrows: Bool?

    @Flag(
        inversion: .prefixedNo,
        help: "Whether it's ok to not have docstring for what a function/method returns. Optional. Default to 'no'.")
    var ignoreReturns: Bool?

    @Option(help: .init("Casing for first letter in keywords such as `Throws`, `Returns`, `Parameter(s)`. Optional (uppercase|lowercase). Default to 'uppercase'.", valueName: "casing"))
    var firstLetter: Configuration.FirstKeywordLetterCasing?

    @Option(help: .init("Sections of docstring that requires separation to the next section. Repeatable, optional (description|parameters|throws).", valueName: "section"))
    var needsSeparation: [Section] = []

    @Flag(help: "Override `needs-separation` so that none is empty.")
    var noNeedsSeparation: Bool = false

    @Flag(
        inversion: .prefixedNo,
        help: "Whether to require descriptions of different parameters to all start on the same column. Optional. Default to 'no'.")
    var verticalAlign: Bool?

    @Option(help: .init("The format used to organize entries of multiple parameters. Optional (grouped|separate|whatever). Defaults to `whatever`.", valueName: "style"))
    var parameterStyle: ParameterStyle?

    @Option(help: .init("Consecutive lines of description should align after `:`. Repeatable, optional (parameters|throws|returns).", valueName: "section"))
    var alignAfterColon: [Section] = []

    @Flag(help: "Override `align-after-colon` so that none is empty.")
    var noAlignAfterColon: Bool = false
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
        version: version,
        subcommands: [
            Check.self,
            Explain.self,
            Format.self,
        ]
    )
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
                --ignore-throws \\
                --first-letter uppercase
        """
    )

    @OptionGroup()
    var options: SharedCommandLineOptions

    @Option(help: "Output format. Terminal format turns on colored text in terminals. Optional (automatic|terminal|plain|paths). Default to `automatic`.")
    var format: Configuration.OutputFormat?

    @Flag(
        inversion: .prefixedNo,
        help: "'yes' prevents DrString from considering an explicitly excluded path superfluous. Optional. Default to `no`.")
    var superfluousExclusion: Bool?

    @Flag(
        inversion: .prefixedNo,
        help: "'yes' prevents DrString from considering a pattern for inclusion or exlusion invalid when the pattern matches no file paths. Optional. Default to `no`.")
    var emptyPatterns: Bool?
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

    @Option(help: .init("Max number of columns a line can fit, beyond which is problematic. Optional integer.", valueName: "column"))
    var columnLimit: Int?

    @Flag(
        inversion: .prefixedNo,
        help: "Add placeholder for an docstring entry if it doesn't exist. Optional. Default to 'no'.")
    var addPlaceholder: Bool?

    @Option(help: .init("First line formatting subcommand should consider affecting, 0 based. Optional number.", valueName: "line"))
    var startLine: Int?

    @Option(help: .init("Last line formatting subcommand should consider affecting, 0 based. Optional number.", valueName: "line"))
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
    var problemID: [String] = []
}
