import DrString
import Guaka

extension DrString.Configuration.Options {
    init(_ flags: Flags) {
        self.init(
            ignoreDocstringForThrows: flags.getBool(name: Constants.ignoreThrows) ?? false,
            verticalAlignParameterDescription: flags.getBool(name: Constants.verticalAlign) ?? false,
            firstKeywordLetter: flags.get(name: Constants.firstLetter, type: DrString.Configuration.FirstKeywordLetterCasing.self) ?? .whatever,
            outputFormat: flags.get(name: Constants.format, type: DrString.Configuration.OutputFormat.self)
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
        var result: Int32? = nil
        self.init(usage: command.name, shortMessage: command.shortDescription, flags: flags)
        { flags, arugements in
            result = command.run(DrString.Configuration(flags), arugements)
        }

        if let code = result {
            exit(code)
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

extension DrString.Configuration.FirstKeywordLetterCasing: FlagValue {
    public static func fromString(flagValue value: String) throws -> DrString.Configuration.FirstKeywordLetterCasing {
        guard let format = Configuration.FirstKeywordLetterCasing(rawValue: value) else {
            throw FlagValueError.conversionError("")
        }

        return format
    }

    public static var typeDescription: String {
        return "output format"
    }
}
