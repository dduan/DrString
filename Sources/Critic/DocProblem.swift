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
        case spaceBeforeParameterName(String, String, String) // Actual, keyword, name
        case spaceBeforeColon(String, String) // Actual, name
        case preDashSpace(String, String) // Keyword, actual
        case spaceBetweenDashAndKeyword(String, String) // Keyword, actual
        case verticalAlignment(Int, String, Int) // Expected, name/keyword, line number
        case spaceAfterColon(String, String) // Keyword, actual
        case keywordCasingForParameter(String, String, String) // Actual, expected, name
        case keywordCasing(String, String) // Actual, expected

        public var explainerID: String {
            switch self {
            case .redundantParameter:
                return "E001"
            case .missingParameter:
                return "E002"
            case .missingThrow:
                return "E003"
            case .missingReturn:
                return "E004"
            case .preDashSpaceInParameter, .preDashSpace:
                return "E005"
            case .spaceBetweenDashAndParamaterKeyword, .spaceBetweenDashAndKeyword:
                return "E006"
            case .spaceBeforeParameterName:
                return "E007"
            case .spaceBeforeColon:
                return "E008"
            case .verticalAlignment:
                return "E009"
            case .spaceAfterColon:
                return "E010"
            case .keywordCasingForParameter, .keywordCasing:
                return "E011"
            }
        }
    }
}
