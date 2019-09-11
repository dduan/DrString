import DrCrawler

public struct DocProblem {
    public let docName: String
    public let filePath: String
    public let line: Int64
    public let column: Int64
    public let details: [Detail]

    public enum Detail {
        case redundantParameter(String)
        case missingParameter(String, String)
        case missingThrow
        case missingReturns(String)
    }
}
