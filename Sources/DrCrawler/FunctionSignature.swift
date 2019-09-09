public struct FunctionSignature {
    public struct Parameter: Equatable {
        public let name: String
        public let type: String

        public init(name: String, type: String) {
            self.name = name
            self.type = type
        }
    }

    public let name: String
    public let parameters: [Parameter]
    public let `throws`: Bool
    public let returnType: String?

    public init(name: String, parameters: [Parameter], `throws`: Bool, returnType: String?) {
        self.name = name
        self.parameters = parameters
        self.throws = `throws`
        self.returnType = returnType
    }
}
