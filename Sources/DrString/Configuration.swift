import Critic

public typealias Section = Critic.Section
public typealias ParameterStyle = Critic.ParameterStyle
public struct Configuration: Decodable {
    let includedPaths: [String]
    let excludedPaths: [String]
    let ignoreDocstringForThrows: Bool
    let ignoreDocstringForReturns: Bool
    let verticalAlignParameterDescription: Bool
    let allowSuperfluousExclusion: Bool
    let firstKeywordLetter: FirstKeywordLetterCasing
    let outputFormat: OutputFormat
    let separatedSections: [Section]
    let parameterStyle: ParameterStyle

    public init(
        includedPaths: [String],
        excludedPaths: [String],
        ignoreDocstringForThrows: Bool,
        ignoreDocstringForReturns: Bool,
        verticalAlignParameterDescription: Bool,
        superfluousExclusion: Bool,
        firstKeywordLetter: FirstKeywordLetterCasing,
        outputFormat: OutputFormat,
        separatedSections: [Section],
        parameterStyle: ParameterStyle
    ) {
        self.includedPaths = includedPaths
        self.excludedPaths = excludedPaths
        self.ignoreDocstringForThrows = ignoreDocstringForThrows
        self.ignoreDocstringForReturns = ignoreDocstringForReturns
        self.verticalAlignParameterDescription = verticalAlignParameterDescription
        self.allowSuperfluousExclusion = superfluousExclusion
        self.firstKeywordLetter = firstKeywordLetter
        self.outputFormat = outputFormat
        self.separatedSections = separatedSections
        self.parameterStyle = parameterStyle
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.includedPaths = try values.decode([String].self, forKey: .include)
        self.excludedPaths = try values.decodeIfPresent([String].self, forKey: .exclude) ?? []
        self.ignoreDocstringForThrows = try values.decodeIfPresent(Bool.self, forKey: .ignoreThrows) ?? false
        self.ignoreDocstringForReturns = try values.decodeIfPresent(Bool.self, forKey: .ignoreReturns) ?? false
        self.verticalAlignParameterDescription = try values.decodeIfPresent(Bool.self, forKey: .verticalAlign) ?? false
        self.allowSuperfluousExclusion = try values.decodeIfPresent(Bool.self, forKey: .superfluousExclusion) ?? false
        self.firstKeywordLetter = try values.decodeIfPresent(FirstKeywordLetterCasing.self, forKey: .firstKeyordLetter) ?? .uppercase
        self.outputFormat = try values.decodeIfPresent(OutputFormat.self, forKey: .format) ?? .automatic
        self.separatedSections = try values.decodeIfPresent([Section].self, forKey: .separations) ?? []
        self.parameterStyle = try values.decodeIfPresent(ParameterStyle.self, forKey: .parameterStyle) ?? .whatever
    }

    enum CodingKeys: String, CodingKey {
        case include = "include"
        case exclude = "exclude"
        case ignoreThrows = "ignore-throws"
        case ignoreReturns = "ignore-returns"
        case verticalAlign = "vertical-align"
        case firstKeyordLetter = "first-letter"
        case format = "format"
        case separations = "needs-separation"
        case superfluousExclusion = "superfluous-exclusion"
        case parameterStyle = "parameter-style"
    }

    public enum OutputFormat: String, Equatable, Decodable {
        case automatic
        case terminal
        case plain
    }

    public enum FirstKeywordLetterCasing: String, Equatable, Decodable {
        case uppercase
        case lowercase
    }
}
