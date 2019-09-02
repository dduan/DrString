import SourceKittenFramework

public struct FunctionSignature {
    public enum Context {
        case free
        case instance
        case `class`
        case staticMethod
    }

    public struct Parameter {
        let name: String
        let type: String
    }

    public let name: String
    public let parameters: [Parameter]
    public let `throws`: Bool
    public let returnType: String?
}

extension FunctionSignature.Context {
    public var declKind: SwiftDeclarationKind {
        switch self {
        case .free:
            return .functionFree
        case .instance:
            return .functionMethodInstance
        case .class:
            return .functionMethodClass
        case .staticMethod:
            return .functionMethodStatic
        }
    }
}
