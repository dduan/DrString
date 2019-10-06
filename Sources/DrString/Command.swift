public struct Command {
    public let name: String
    public let aliases: [String]
    public let shortDescription: String
    /// optionally return a status code for exiting
    public let run: (Configuration, [String]) -> Int32?
}
