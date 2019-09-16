import DrString
import Guaka

extension DrString.Configuration.Options {
    init(_ flags: Flags) {
        self.init(
            ignoreDocstringForThrows: flags.getBool(name: Constants.ignoreThrows) ?? false,
            outputFormat: flags.get(name: "format", type: DrString.Configuration.OutputFormat.self)
                ?? .automatic
        )
    }
}

extension DrString.Configuration {
    init(_ flags: Flags) {
        self.init(
            includedPaths: flags[valuesForName: Constants.include] as? [String] ?? [],
            excludedPaths: flags[valuesForName: Constants.exclude] as? [String] ?? [],
            options: Options(flags))
    }
}

extension Guaka.Command {
    convenience init(_ command: DrString.Command, flags: [Flag]) {
        self.init(usage: command.name, shortMessage: command.shortDescription, flags: flags) { flags, _ in
            command.run(DrString.Configuration(flags))
        }
    }
}

extension DrString.Configuration.OutputFormat: FlagValue {
    public static func fromString(flagValue value: String) throws -> DrString.Configuration.OutputFormat {
        guard let format = Configuration.OutputFormat(rawValue: value) else {
            throw FlagValueError.conversionError("")
        }

        return format
    }

    public static var typeDescription: String {
        return "output format"
    }

}
