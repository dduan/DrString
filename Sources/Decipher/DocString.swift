public struct DocString: Equatable {
    public struct Entry: Equatable {
        public let preDashWhitespace: String
        public let keyword: TextLeadByWhitespace?
        public let name: TextLeadByWhitespace
        public let preColonWhitespace: String
        public let description: [TextLeadByWhitespace]

        public init(preDashWhitespaces: String, keyword: TextLeadByWhitespace?, name: TextLeadByWhitespace,
                    preColonWhitespace: String, description: [TextLeadByWhitespace])
        {
            self.preDashWhitespace = preDashWhitespaces
            self.keyword = keyword
            self.name = name
            self.preColonWhitespace = preColonWhitespace
            self.description = description
        }
    }

    public let description: [TextLeadByWhitespace]
    public let parameterHeader: Entry?
    public let parameters: [Entry]
    public let returns: Entry?
    public let `throws`: Entry?

    public init(description: [TextLeadByWhitespace], parameterHeader: Entry?, parameters: [Entry], returns: Entry?, throws: Entry?) {
        self.description = description
        self.parameterHeader = parameterHeader
        self.parameters = parameters
        self.returns = returns
        self.throws = `throws`
    }
}
