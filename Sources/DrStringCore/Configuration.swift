import Models

public struct Configuration: Codable {
    public var includedPaths: [String] = []
    public var excludedPaths: [String] = []
    public var ignoreDocstringForThrows: Bool = false
    public var ignoreDocstringForReturns: Bool = false
    public var verticalAlignParameterDescription: Bool = false
    public var allowSuperfluousExclusion: Bool = false
    public var allowEmptyPatterns: Bool = false
    public var firstKeywordLetter: FirstKeywordLetterCasing = .uppercase
    public var outputFormat: OutputFormat = .automatic
    public var separatedSections: [Section] = []
    public var parameterStyle: ParameterStyle = .whatever
    public var alignAfterColon: [Section] = []
    public var columnLimit: Int?
    public var addPlaceholder: Bool = false
    public var startLine: Int?
    public var endLine: Int?

    public init() {}
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

        if let allowEmptyPatterns = try values.decodeIfPresent(Bool.self, forKey: .emptyPatterns) {
            config.allowEmptyPatterns = allowEmptyPatterns
        }

        if let firstKeywordLetter = try values.decodeIfPresent(FirstKeywordLetterCasing.self, forKey: .firstKeywordLetter) {
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

        if let addPlaceholder = try values.decodeIfPresent(Bool.self, forKey: .addPlaceholder) {
            config.addPlaceholder = addPlaceholder
        }

        if let startLine = try values.decodeIfPresent(Int.self, forKey: .startLine) {
            config.startLine = startLine
        }

        if let endLine = try values.decodeIfPresent(Int.self, forKey: .endLine) {
            config.endLine = endLine
        }

        self = config
    }

    public func encode(to encoder: Encoder) throws {
        var values = encoder.container(keyedBy: CodingKeys.self)
        try values.encodeIfPresent(self.endLine, forKey: .endLine)
        try values.encodeIfPresent(self.startLine, forKey: .startLine)
        try values.encodeIfPresent(self.columnLimit, forKey: .columnLimit)
        try values.encode(self.addPlaceholder, forKey: .addPlaceholder)
        try values.encode(self.alignAfterColon, forKey: .alignAfterColon)
        try values.encode(self.parameterStyle, forKey: .parameterStyle)
        try values.encode(self.separatedSections, forKey: .separations)
        try values.encode(self.outputFormat, forKey: .format)
        try values.encode(self.firstKeywordLetter, forKey: .firstKeywordLetter)
        try values.encode(self.allowSuperfluousExclusion, forKey: .superfluousExclusion)
        try values.encode(self.allowEmptyPatterns, forKey: .emptyPatterns)
        try values.encode(self.verticalAlignParameterDescription, forKey: .verticalAlign)
        try values.encode(self.ignoreDocstringForReturns, forKey: .ignoreReturns)
        try values.encode(self.ignoreDocstringForThrows, forKey: .ignoreThrows)
        try values.encode(self.excludedPaths, forKey: .exclude)
        try values.encode(self.includedPaths, forKey: .include)
    }


    enum CodingKeys: String, CodingKey {
        case include = "include"
        case exclude = "exclude"
        case ignoreThrows = "ignore-throws"
        case ignoreReturns = "ignore-returns"
        case verticalAlign = "vertical-align"
        case firstKeywordLetter = "first-letter"
        case format = "format"
        case separations = "needs-separation"
        case superfluousExclusion = "superfluous-exclusion"
        case emptyPatterns = "empty-patterns"
        case parameterStyle = "parameter-style"
        case alignAfterColon = "align-after-colon"
        case columnLimit = "column-limit"
        case addPlaceholder = "add-placeholder"
        case startLine = "start-line"
        case endLine = "end-line"
    }

    public enum OutputFormat: String, Equatable, Codable {
        case automatic
        case terminal
        case plain
        case paths
    }

    public enum FirstKeywordLetterCasing: String, Equatable, Codable {
        case uppercase
        case lowercase
    }
}
