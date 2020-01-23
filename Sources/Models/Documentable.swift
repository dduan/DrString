public struct Parameter: Equatable {
    public let label: String?
    public let name: String
    public let type: String
    public let isVariadic: Bool
    public let hasDefault: Bool

    public init(
        label: String?,
        name: String,
        type: String,
        isVariadic: Bool,
        hasDefault: Bool)
    {
        self.label = label
        self.name = name
        self.type = type
        self.isVariadic = isVariadic
        self.hasDefault = hasDefault
    }
}

public struct EnumCase: Equatable {
    let name: String
    let parameters: [Parameter]
}

public struct Documentable: Equatable {
    public let path: String
    public let startLine: Int
    public let startColumn: Int
    public let endLine: Int
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

    public init(
        path: String,
        startLine: Int,
        startColumn: Int,
        endLine: Int,
        name: String,
        docLines: [String],
        children: [Documentable],
        details: Details)
    {
        self.path = path
        self.startLine = startLine
        self.startColumn = startColumn
        self.endLine = endLine
        self.name = name
        self.docLines = docLines
        self.children = children
        self.details = details
    }
}
