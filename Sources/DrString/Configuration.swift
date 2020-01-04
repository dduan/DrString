import Decipher

public typealias Section = Decipher.Section
public typealias ParameterStyle = Decipher.ParameterStyle

public struct Configuration: Decodable {
    public var includedPaths: [String] = []
    public var excludedPaths: [String] = []
    public var ignoreDocstringForThrows: Bool = false
    public var ignoreDocstringForReturns: Bool = false
    public var verticalAlignParameterDescription: Bool = false
    public var allowSuperfluousExclusion: Bool = false
    public var firstKeywordLetter: FirstKeywordLetterCasing = .uppercase
    public var outputFormat: OutputFormat = .automatic
    public var separatedSections: [Section] = []
    public var parameterStyle: ParameterStyle = .whatever
    public var alignAfterColon: [Section] = []
    public var columnLimit: Int?

    public init() {}
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
        parameterStyle: ParameterStyle,
        alignAfterColon: [Section],
        columnLimit: Int?
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
        self.alignAfterColon = alignAfterColon
        self.columnLimit = columnLimit
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        var config = Configuration()

        config.includedPaths = try values.decode([String].self, forKey: .include)
        config.columnLimit = try values.decodeIfPresent(Int.self, forKey: .columnLimit)

        if let excludedPaths = try values.decodeIfPresent([String].self, forKey: .exclude) {
            config.excludedPaths = excludedPaths
        }

        if let ignoreDocstringForThrows = try values.decodeIfPresent(Bool.self, forKey: .ignoreThrows) {
            config.ignoreDocstringForThrows = ignoreDocstringForThrows
        }

        if let ignoreDocstringForReturns = try values.decodeIfPresent(Bool.self, forKey: .ignoreReturns) {
            config.ignoreDocstringForReturns = ignoreDocstringForReturns
        }

        if let verticalAlignParameterDescription = try values.decodeIfPresent(Bool.self, forKey: .verticalAlign) {
            config.verticalAlignParameterDescription = verticalAlignParameterDescription
        }

        if let allowSuperfluousExclusion = try values.decodeIfPresent(Bool.self, forKey: .superfluousExclusion) {
            config.allowSuperfluousExclusion = allowSuperfluousExclusion
        }

        if let firstKeywordLetter = try values.decodeIfPresent(FirstKeywordLetterCasing.self, forKey: .firstKeyordLetter) {
            config.firstKeywordLetter = firstKeywordLetter
        }

        if let outputFormat = try values.decodeIfPresent(OutputFormat.self, forKey: .format) {
            config.outputFormat = outputFormat
        }

        if let separatedSections = try values.decodeIfPresent([Section].self, forKey: .separations) {
            config.separatedSections = separatedSections
        }

        if let parameterStyle = try values.decodeIfPresent(ParameterStyle.self, forKey: .parameterStyle) {
            config.parameterStyle = parameterStyle
        }

        if let alignAfterColon = try values.decodeIfPresent([Section].self, forKey: .alignAfterColon) {
            config.alignAfterColon = alignAfterColon
        }

        self = config
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
        case alignAfterColon = "align-after-colon"
        case columnLimit = "column-limit"
    }

    public enum OutputFormat: String, Equatable, Decodable {
        case automatic
        case terminal
        case plain
        case paths
    }

    public enum FirstKeywordLetterCasing: String, Equatable, Decodable {
        case uppercase
        case lowercase
    }
}
