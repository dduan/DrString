public struct Command {
    public let name: String
    public let shortDescription: String
    public let run: (Configuration) -> Void
}
