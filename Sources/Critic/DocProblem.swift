import Crawler

public struct DocProblem {
    public let docName: String
    public let filePath: String
    public let line: Int
    public let column: Int
    public let details: [Detail]

    public init(docName: String, filePath: String, line: Int, column: Int, details: [Detail]) {
        self.docName = docName
        self.filePath = filePath
        self.line = line
        self.column = column
        self.details = details
    }

    public enum Detail {
        case redundantParameter(String)
        case missingParameter(String, String)
        case missingThrow
        case missingReturn(String)
        case preDashSpaceInParameter(Int, String, String) // expected, actual, name
        case spaceBetweenDashAndParameterKeyword(String, String, String) // Actual, keyword, name
        case spaceBeforeParameterName(String, String, String) // Actual, keyword, name
        case spaceBeforeColon(String, String) // Actual, name
        case preDashSpace(String, String) // Keyword, actual
        case spaceBetweenDashAndKeyword(String, String) // Keyword, actual
        case verticalAlignment(Int, String, Int) // Expected, name/keyword, line number
        case spaceAfterColon(String, String) // Keyword, actual
        case keywordCasingForParameter(String, String, String) // Actual, expected, name
        // TODO: it's also about spelling of the keywords
        case keywordCasing(String, String) // Actual, expected
        case descriptionShouldEndWithEmptyLine
        case sectionShouldEndWithEmptyLine(String) // keyword or parameter name
        case redundantKeyword(String) // keyword
        case redundantTextFollowingParameterHeader(String) // keyword
        case excludedYetNoProblemIsFound(String) // config path
        case excludedYetNotIncluded
        case parametersAreNotGrouped
        case parametersAreNotSeparated

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
            case .spaceBetweenDashAndParameterKeyword, .spaceBetweenDashAndKeyword:
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
            case .descriptionShouldEndWithEmptyLine, .sectionShouldEndWithEmptyLine:
                return "E012"
            case .redundantKeyword:
                return "E013"
            case .redundantTextFollowingParameterHeader:
                return "E014"
            case .excludedYetNoProblemIsFound:
                return "E015"
            case .excludedYetNotIncluded:
                return "E016"
            case .parametersAreNotGrouped:
                return "E017"
            case .parametersAreNotSeparated:
                return "E018"
            }
        }
    }
}
