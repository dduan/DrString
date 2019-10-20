import DrString
import Guaka

extension DrString.Configuration {
    init(_ flags: Flags) {
        self.init(
            includedPaths: flags[valuesForName: Constants.include] as? [String] ?? [],
            excludedPaths: flags[valuesForName: Constants.exclude] as? [String] ?? [],
            ignoreDocstringForThrows: flags.getBool(name: Constants.ignoreThrows) ?? false,
            ignoreDocstringForReturns: flags.getBool(name: Constants.ignoreReturns) ?? false,
            verticalAlignParameterDescription: flags.getBool(name: Constants.verticalAlign) ?? false,
            superfluousExclusion: flags.getBool(name: Constants.superfluousExclusion) ?? false,
            firstKeywordLetter: flags.get(name: Constants.firstLetter, type: DrString.Configuration.FirstKeywordLetterCasing.self) ?? .uppercase,
            outputFormat: flags.get(name: Constants.format, type: DrString.Configuration.OutputFormat.self) ?? .automatic,
            separatedSections: flags.get(name: Constants.separations, type: [Section].self) ?? []
        )
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
        "(automatic|terminal|plain)"
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
        "(uppercase|lowercase)"
    }
}

extension Section: FlagValue {
    public static func fromString(flagValue value: String) throws -> Section {
        guard let section = Section(rawValue: value) else {
            throw FlagValueError.conversionError("")
        }

        return section
    }

    public static var typeDescription: String {
        "(description|parameters|throws)"
    }
}
