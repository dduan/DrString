import DrString
import Guaka

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
    print(mainCommand.helpMessage)
} else {
    mainCommand.execute()
}
