import Foundation
import DrString
import Guaka
import TOMLDecoder

let flags = [
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
        type : DrString.Configuration.OutputFormat.self,
        description: "Output format. (automatic|terminal|plain)")
]

let checkCommand = Guaka.Command(DrString.checkCommand, flags: flags)

var mainCommand = Guaka.Command(usage: "drstring")
mainCommand.add(subCommand: checkCommand)

if CommandLine.argc <= 1 {
    guard let configText = try? String(contentsOfFile: ".drstring.toml") else {
        fputs("Couldn't read configruation from .drstring.toml\n", stderr)
        exit(1)
    }

    guard let config = try? TOMLDecoder().decode(DrString.Configuration.self, from: configText) else {
        fputs("Couldn't decode valid configuration from .drstring.toml", stderr)
        exit(1)
    }

    DrString.checkCommand.run(config)
} else {
    mainCommand.execute()
}
