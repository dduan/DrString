public struct AbsoluteSourceLocation: Equatable, Codable {
    public var path: String
    public var line: Int
    public var column: Int

    public init(path: String = "", line: Int = 0, column: Int = 0) {
        self.path = path
        self.line = line
        self.column = column
    }
}
