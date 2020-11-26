import Models

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
        case groupedParametersHeader(String, TextLeadByWhitespace, String, Bool, TextLeadByWhitespace)
        case groupedParameter(String, TextLeadByWhitespace, String, Bool, TextLeadByWhitespace) // name, description, raw text
        case parameter(String, TextLeadByWhitespace, TextLeadByWhitespace, String, Bool, TextLeadByWhitespace)
        case `returns`(String, TextLeadByWhitespace, String, Bool, TextLeadByWhitespace)
        case `throws`(String, TextLeadByWhitespace, String, Bool, TextLeadByWhitespace)
    }

    enum LineError: Error {
        case missingCommentHead(String)
    }

    enum StructuralError: Error {
        case invalidStart
    }
}
