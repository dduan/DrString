public struct Parameter: Equatable, Codable {
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

public struct Documentable: Equatable, Codable {
    public let path: String
    public let startLine: Int
    public let startColumn: Int
    public let endLine: Int
    public let name: String
    public let docLines: [String]
    public let children: [Documentable]
    public let details: Details

    public struct Details: Equatable, Codable {
        public let `throws`: Bool
        public let returnType: String?
        public let parameters: [Parameter]

        public init(throws: Bool, returnType: String?, parameters: [Parameter]) {
            self.throws = `throws`
            self.returnType = returnType
            self.parameters = parameters
        }
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
