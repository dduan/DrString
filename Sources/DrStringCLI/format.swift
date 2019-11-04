import DrString
import Editor
import Guaka
import Pathos
import TOMLDecoder

func format(flags: Flags, arguments: [String], help: String) {
    let config: DrString.Configuration
    let path = ".drstring.toml"
    if (try? isA(.file, atPath: path)) == .some(true) {
        guard let configText = try? readString(atPath: path),
            let decoded = try? TOMLDecoder().decode(DrString.Configuration.self, from: configText) else
        {
            fputs("Tried to run `format`, but \(path) doesn't contain a valid config file.\n", stderr)
            fputs(help, stderr)
            exit(EXIT_FAILURE)
        }

        config = decoded
    } else {
        config = DrString.Configuration(flags)
    }

    format(with: config)
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
TODO
"""

private let example = """
TODO
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
        format(flags: flags, arguments: arguments, help: command.helpMessage)
    }
    return command
}()
