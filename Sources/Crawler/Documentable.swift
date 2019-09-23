import Decipher

public struct Parameter: Equatable {
    public let label: String?
    public let name: String
    public let type: String
    public let isVariadic: Bool
    public let hasDefault: Bool
}

public struct EnumCase: Equatable {
    let name: String
    let parameters: [Parameter]
}

public struct Documentable: Equatable {
    public let path: String
    public let line: Int
    public let column: Int
    public let name: String
    public let docLines: [String]
    public let children: [Documentable]
    public let details: Details

    public enum Details: Equatable {
        case function(`throws`: Bool, returnType: String?, parameters: [Parameter])
        case variable(mutable: Bool)
        case `class`
        case `enum`(cases: [EnumCase])
        case `extension`
        case `protocol`
        case `struct`
    }
}
