enum Parsing {
    enum State {
        case start
        case description
        case groupedParameterStart
        case groupedParameter
        case separateParameter
        case `returns`
        case `throws`
    }

    enum LineResult: Equatable {
        case words(TextLeadByWhitespace)
        case groupedParametersHeader(String, TextLeadByWhitespace) // raw text is preserved. it could be part of description
        case groupedParameter(String, TextLeadByWhitespace, String, TextLeadByWhitespace) // name, description, raw text
        case parameter(String, TextLeadByWhitespace, TextLeadByWhitespace, String, TextLeadByWhitespace)
        case `returns`(String, TextLeadByWhitespace, String, TextLeadByWhitespace)
        case `throws`(String, TextLeadByWhitespace, String, TextLeadByWhitespace)
    }

    enum LineError: Error {
        case mismatchWithExpectedResult(String)
        case missingCommentHead(String)
    }

    enum StructuralError: Error {
        case invalidStart
        case badFormat
    }
}
