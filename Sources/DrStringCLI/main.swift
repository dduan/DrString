import DrString
import Guaka
import TOMLDecoder

#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif

let checkFlags = [
    Flag(
        longName: Constants.ignoreThrows,
        value: false,
        description: "Consider it ok to not have docstring for what a function/method throws."),
    Flag(
        shortName: "i",
        longName: Constants.include,
        values: [String](),
        description: "Paths included for DrString to operate on."),
    Flag(
        shortName: "x",
        longName: Constants.exclude,
        type: [String].self,
        description: "Paths excluded for DrString to operate on"),
    Flag(
        shortName: "f",
        longName: "format",
        type: DrString.Configuration.OutputFormat.self,
        description: "Output format. (automatic|terminal|plain)"),
    Flag(
        shortName: "c",
        longName: "first-letter",
        type : DrString.Configuration.FirstKeywordLetterCasing.self,
        description: "Casing for first letter in keywords such as `Throws`, `Returns`, `Parameter(s)`"),
    Flag(
        shortName: "s",
        longName: Constants.separations,
        type: [Section].self,
        description: "Sections of docstring that requires separation to the next section"),
    Flag(
        shortName: "v",
        longName: Constants.verticalAlign,
        type: Bool.self,
        description: "Vertical align descriptions of parameters."),
]

let checkCommand = Guaka.Command(DrString.checkCommand, flags: checkFlags)
let explainCommand = Guaka.Command(DrString.explainCommand, flags: [])
explainCommand.usage = "explain ID1 ID2 …"
explainCommand.preRun = { _, arguments in
    if arguments.count < 1 {
        print(explainCommand.helpMessage)
        return false
    }

    return true
}

var mainCommand = Guaka.Command(usage: "drstring") { flags, arguments in
    guard let configText = try? String(contentsOfFile: ".drstring.toml") else {
        fputs("Couldn't read configruation from .drstring.toml\n", stderr)
        exit(1)
    }

    guard let config = try? TOMLDecoder().decode(DrString.Configuration.self, from: configText) else {
        fputs("Couldn't decode valid configuration from .drstring.toml", stderr)
        exit(1)
    }

    if let code = DrString.checkCommand.run(config, arguments) {
        exit(code)
    }
}

mainCommand.add(subCommand: checkCommand)
mainCommand.add(subCommand: explainCommand)
mainCommand.execute()
