/// A change to a file. All changes are assumed to be a range of lines.
public struct Edit {
    public let startingLine: Int
    public let endingLine: Int
    public let text: [String]
}
