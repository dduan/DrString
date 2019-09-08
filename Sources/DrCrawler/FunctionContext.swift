import SourceKittenFramework

public enum FunctionContext {
    case free
    case instance
    case `class`
    case staticMethod
}

extension FunctionContext {
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
