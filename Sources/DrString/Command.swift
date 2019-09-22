public struct Command {
    public let name: String
    public let shortDescription: String
    /// optionally return a status code for exiting
    public let run: (Configuration) -> Int32?
}
