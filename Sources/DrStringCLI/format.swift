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
        let options = ParsedOptions(from: flags, arguments: arguments)
        format(with: options, help: command.helpMessage)
    }
    return command
}()
