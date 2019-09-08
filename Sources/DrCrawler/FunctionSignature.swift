public struct FunctionSignature {
    public struct Parameter {
        public let name: String
        public let type: String
    }

    public let name: String
    public let parameters: [Parameter]
    public let `throws`: Bool
    public let returnType: String?
}
