import DrString
import Guaka
import TOMLDecoder
import Pathos

#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif

let checkFlags = [
    Flag(
        longName: Constants.ignoreThrows,
        type: Bool.self,
        description: "Whether it's ok to not have docstring for what a function/method throws."),
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
        description: "Output format. Terminal format turns on colored text in terminals."),
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
        longName: Constants.verticalAlign,
        type: Bool.self,
        description: "Whether to require descriptions of different parameters to all start on the same column."),
]


let explainCommand = Guaka.Command(DrString.explainCommand, flags: [])
explainCommand.usage = "explain ID1 ID2 …"
explainCommand.preRun = { _, arguments in
    if arguments.count < 1 {
        print(explainCommand.helpMessage)
        return false
    }

    return true
}

func check(flags: Flags, arguments: [String]) -> Int32 {
    let config: DrString.Configuration
    let path = ".drstring.toml"
    if (try? isA(.file, atPath: path)) == .some(true) {
        guard let configText = try? readString(atPath: ".drstring.toml"),
            let decoded = try? TOMLDecoder().decode(DrString.Configuration.self, from: configText) else
        {
            fputs("Tried to run `check`, but \(path) doesn't contain a valid config file.", stderr)
            return EXIT_FAILURE
        }

        config = decoded
    } else {
        config = DrString.Configuration(flags)
    }

    return DrString.checkCommand.run(config, arguments) ?? EXIT_SUCCESS
}

let checkCommand = Guaka.Command(
    usage: "check [-i PATTERN]...",
    shortMessage: DrString.checkCommand.shortDescription,
    flags: checkFlags)
{
    _ = check(flags: $0, arguments: $1)
}

var mainCommand = Guaka.Command(usage: "drstring")
mainCommand.run = { flags, arguments in
    if check(flags: flags, arguments: arguments) != EXIT_SUCCESS {
        fputs("\n\(mainCommand.helpMessage)", stderr)
    }
}

mainCommand.add(subCommand: checkCommand)
mainCommand.add(subCommand: explainCommand)
mainCommand.execute()
