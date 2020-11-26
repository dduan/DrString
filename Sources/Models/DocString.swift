public struct DocString: Equatable, Codable {
    public struct Entry: Equatable, Codable {
        public let preDashWhitespace: String
        public let keyword: TextLeadByWhitespace?
        public let name: TextLeadByWhitespace
        public let preColonWhitespace: String
        public let hasColon: Bool
        public let description: [TextLeadByWhitespace]

        public init(preDashWhitespaces: String, keyword: TextLeadByWhitespace?, name: TextLeadByWhitespace,
                    preColonWhitespace: String, hasColon: Bool, description: [TextLeadByWhitespace])
        {
            self.preDashWhitespace = preDashWhitespaces
            self.keyword = keyword
            self.name = name
            self.preColonWhitespace = preColonWhitespace
            self.hasColon = hasColon
            self.description = description
        }
    }

    public var description: [TextLeadByWhitespace]
    public var parameterHeader: Entry?
    public var parameters: [Entry]
    public var returns: Entry?
    public var `throws`: Entry?

    public init(description: [TextLeadByWhitespace], parameterHeader: Entry?, parameters: [Entry], returns: Entry?, throws: Entry?) {
        self.description = description
        self.parameterHeader = parameterHeader
        self.parameters = parameters
        self.returns = returns
        self.throws = `throws`
    }
}
