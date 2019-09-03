public struct FunctionSignature {
    public struct Parameter {
        let name: String
        let type: String
    }

    public let name: String
    public let parameters: [Parameter]
    public let `throws`: Bool
    public let returnType: String?
}
