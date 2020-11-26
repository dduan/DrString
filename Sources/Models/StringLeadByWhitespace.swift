public struct TextLeadByWhitespace: Equatable, Codable {
    public let lead: String
    public let text: String

    public init(_ lead: String, _ text: String) {
        self.lead = lead
        self.text = text
    }

    public static let empty = TextLeadByWhitespace("", "")
}

extension TextLeadByWhitespace: CustomStringConvertible {
    public var description: String {
        "\(self.lead)\(self.text)"
    }
}
