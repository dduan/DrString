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
        case words(String)
        case groupedParametersHeader(String) // raw text is preserved. it could be part of description
        case groupedParameter(String, String, String) // name, description, raw text
        case parameter(String, String)
        case `returns`(String)
        case `throws`(String)
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
