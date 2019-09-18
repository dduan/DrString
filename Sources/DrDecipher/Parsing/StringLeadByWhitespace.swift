public struct TextLeadByWhitespace: Equatable {
    public let lead: String
    public let text: String

    init(_ lead: String, _ text: String) {
        self.lead = lead
        self.text = text
    }
}
