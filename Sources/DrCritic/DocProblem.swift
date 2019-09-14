import DrCrawler

public struct DocProblem {
    public let docName: String
    public let filePath: String
    public let line: Int
    public let column: Int
    public let details: [Detail]

    public enum Detail {
        case redundantParameter(String)
        case missingParameter(String, String)
        case missingThrow
        case missingReturn(String)
    }
}
