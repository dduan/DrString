import Crawler

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
        case preDashSpaceInParameter(Int, String, String) // Actual, expected, name
        case spaceBetweenDashAndParamaterKeyword(String, String, String) // Actual, keyword, name
        case keywordSpellingForParameter(String, String, String) // Actual, expected, name
        case spaceBeforeParameterName(String, String, String) // Actual, keyword, name
    }
}
