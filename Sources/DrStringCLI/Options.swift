import Guaka
import DrString

enum Options {
    static let ignoreThrows = Flag(
        longName: Constants.ignoreThrows,
        type: Bool.self,
        description: "Whether it's ok to not have docstring for what a function/method throws.")
    static let ignoreReturns = Flag(
        longName: Constants.ignoreReturns,
        type: Bool.self,
        description: "Whether it's ok to not have docstring for what a function/method returns.")
    static let include = Flag(
        shortName: "i",
        longName: Constants.include,
        type: [String].self,
        description: "Paths included for DrString to operate on.")
    static let exclude = Flag(
        shortName: "x",
        longName: Constants.exclude,
        type: [String].self,
        description: "Paths excluded for DrString to operate on")
    static let format = Flag(
        shortName: "f",
        longName: Constants.format,
        type: DrString.Configuration.OutputFormat.self,
        description: "Output format. Terminal format turns on colored text in terminals.")
    static let firstLetter = Flag(
        shortName: "c",
        longName: Constants.firstLetter,
        type : DrString.Configuration.FirstKeywordLetterCasing.self,
        description: "Casing for first letter in keywords such as `Throws`, `Returns`, `Parameter(s)`")
    static let parameterStyle = Flag(
        longName: Constants.parameterStyle,
        type : DrString.ParameterStyle.self,
        description: "The format used to organize entries of multiple parameters")
    static let separations = Flag(
        shortName: "s",
        longName: Constants.separations,
        type: [Section].self,
        description: "Sections of docstring that requires separation to the next section")
    static let verticalAlign = Flag(
        longName: Constants.verticalAlign,
        type: Bool.self,
        description: "Whether to require descriptions of different parameters to all start on the same column.")
    static let superfluousExclusion = Flag(
        longName: Constants.superfluousExclusion,
        type: Bool.self,
        description: "`True` prevents DrString from considering an excluded path superfluous.")
    static let alignAfterColon = Flag(
        longName: Constants.alignAfterColon,
        type: [Section].self,
        description: "Consecutive lines of description should align after `:`")
    static let columnLimit = Flag(
        longName: Constants.columnLimit,
        type: Int.self,
        description: "Max number of columns a line can fit, beyond which is problematic.")
    static let configFile = Flag(
        longName: Constants.configFile,
        type: String.self,
        description: "Path to the configuration TOML file.")
}
