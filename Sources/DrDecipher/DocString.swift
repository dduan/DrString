public struct DocString: Equatable {
    public struct Parameter: Equatable {
        public let name: String
        public let description: [TextLeadByWhitespace]

        public init(name: String, description: [TextLeadByWhitespace]) {
            self.name = name
            self.description = description
        }
    }

    public let description: [String]
    public let parameters: [Parameter]
    public let returns: [String]
    public let `throws`: [String]
    public let maxParameterWidth: Int

    public init(description: [String], parameters: [Parameter], returns: [String], throws: [String]) {
        self.description = description
        self.parameters = parameters
        self.returns = returns
        self.throws = `throws`
        self.maxParameterWidth = parameters.reduce(0) { max($0, $1.name.count) }
    }
}
