import TSCUtility

private let kDefaultConfigurationPath = ".drstring.toml"
extension Section: ArgumentKind {
    public init(argument: String) throws {
        guard let section = Section(rawValue: argument) else {
            throw ArgumentConversionError.typeMismatch(value: argument, expectedType: Section.self)
        }

        self = section
    }

    public static let completion: ShellCompletion = .values([
        (value: "description", description: "Overall description of the docstring"),
        (value: "parameters", description: "Docstring for parameters"),
        (value: "throws", description: "Docstring for what a function throws"),
        (value: "returns", description: "Docstring for what a function returns"),
    ])
}

extension Configuration.OutputFormat: ArgumentKind {
    public init(argument: String) throws {
        guard let format = Self(rawValue: argument) else {
            throw ArgumentConversionError.typeMismatch(value: argument, expectedType: Self.self)
        }

        self = format
    }

    public static let completion: ShellCompletion = .values([
        (value: "automatic", description: "Enable and disable colored output automatically"),
        (value: "terminal", description: "Assume output is ANSI terminal that can display colors"),
        (value: "plain", description: "Output plain text"),
        (value: "paths", description: "Only display paths to files with prolems"),
    ])
}

extension Configuration.FirstKeywordLetterCasing: ArgumentKind {
    public init(argument: String) throws {
        guard let format = Self(rawValue: argument) else {
            throw ArgumentConversionError.typeMismatch(value: argument, expectedType: Self.self)
        }

        self = format
    }

    public static let completion: ShellCompletion = .values([
        (value: "lowercase", description: "Expect first letter of docstring keyword to be lowercase"),
        (value: "uppercase", description: "Expect first letter of docstring keyword to be uppercase"),
    ])
}

extension ParameterStyle: ArgumentKind {
    public init(argument: String) throws {
        guard let format = Self(rawValue: argument) else {
            throw ArgumentConversionError.typeMismatch(value: argument, expectedType: Self.self)
        }

        self = format
    }

    public static let completion: ShellCompletion = .values([
        (value: "grouped", description: "Expect all parameter docstring should share a header"),
        (value: "separate", description: "Expect each parameter docstring to include a header"),
        (value: "whatever", description: "Have no expectation of which style is correct"),
    ])
}
