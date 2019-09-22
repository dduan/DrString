public struct TextLeadByWhitespace: Equatable {
    public let lead: String
    public let text: String

    init(_ lead: String, _ text: String) {
        self.lead = lead
        self.text = text
    }

    static let empty = TextLeadByWhitespace("", "")
}

extension TextLeadByWhitespace: CustomStringConvertible {
    public var description: String {
        "\(self.lead)\(self.text)"
    }
}
