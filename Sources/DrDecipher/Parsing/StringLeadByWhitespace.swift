public struct TextLeadByWhitespace: Equatable {
    public let lead: String
    public let text: String

    init(_ lead: String, _ text: String) {
        self.lead = lead
        self.text = text
    }
}

extension TextLeadByWhitespace: CustomStringConvertible {
    public var description: String {
        "\(self.lead)\(self.text)"
    }
}
