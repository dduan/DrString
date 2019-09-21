public struct DocString: Equatable {
    public struct Parameter: Equatable {
        public let preDashWhitespace: String
        public let keyword: TextLeadByWhitespace?
        public let preColonWhitespace: String
        public let name: TextLeadByWhitespace
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
    public let parameters: [Parameter]
    public let returns: [TextLeadByWhitespace]
    public let `throws`: [TextLeadByWhitespace]
    public let maxParameterWidth: Int

    public init(description: [TextLeadByWhitespace], parameters: [Parameter], returns: [TextLeadByWhitespace],
                throws: [TextLeadByWhitespace])
    {
        self.description = description
        self.parameters = parameters
        self.returns = returns
        self.throws = `throws`
        self.maxParameterWidth = parameters.reduce(0) { max($0, $1.name.text.count) }
    }
}
