public func parse(lines: [String]) throws -> DocString {
    assert(!lines.isEmpty)
    guard
        let firstLine = lines.first,
        let _ = firstLine.firstIndex(where: { !$0.isWhitespace })
        else
    {
        throw Parsing.StructuralError.invalidStart
    }

    var topLevelDescription = [TextLeadByWhitespace]()
    var returnDescription = [TextLeadByWhitespace]()
    var throwDescription = [TextLeadByWhitespace]()
    var runningDescription = [TextLeadByWhitespace]()
    var parameterName = TextLeadByWhitespace.empty
    var parameters = [DocString.Parameter]()
    var state = Parsing.State.start

    func concludeParamater() {
        let parameter = DocString.Parameter(name: parameterName, description: runningDescription)
        parameters.append(parameter)
    }

    for line in lines {
        let parsed = try parse(line: line)
        switch (state, parsed) {
        case (.start, .words(let newWords)):
            state = .description
            runningDescription = [newWords]
        case (.start, .groupedParametersHeader):
            state = .groupedParameterStart
        case (.start, .groupedParameter(_, _, _, let text)):
            state = .description
            runningDescription = [text]
        case (.start, .parameter(_, _, let name, _, let text)):
            state = .separateParameter
            parameterName = name
            runningDescription = [text]
        case (.start, .returns(_, _, _, let text)):
            state = .returns
            runningDescription = [text]
        case (.start, .throws(_, _, _, let text)):
            state = .throws
            runningDescription = [text]

        case (.description, .groupedParametersHeader):
            state = .groupedParameterStart
            topLevelDescription = runningDescription
            runningDescription = []
        case (.description, .groupedParameter(_, _, _, let text)):
            runningDescription.append(text)
        case (.description, .parameter(_, _, let name, _, let text)):
            topLevelDescription = runningDescription
            state = .separateParameter
            runningDescription = [text]
            parameterName = name
        case (.description, .returns(_, _, _, let text)):
            topLevelDescription = runningDescription
            state = .returns
            runningDescription = [text]
        case (.description, .throws(_, _, _, let text)):
            topLevelDescription = runningDescription
            state = .throws
            runningDescription = [text]

        case (.separateParameter, .groupedParametersHeader):
            concludeParamater()
            state = .groupedParameterStart
            runningDescription = []
        case (.separateParameter, .groupedParameter(_, _, _, let text)):
            runningDescription.append(text)
        case (.separateParameter, .parameter(_, _, let name, _, let text)):
            concludeParamater()
            parameterName = name
            runningDescription = [text]
        case (.separateParameter, .returns(_, _, _, let text)):
            concludeParamater()
            state = .returns
            runningDescription = [text]
        case (.separateParameter, .throws(_, _, _, let text)):
            concludeParamater()
            state = .throws
            runningDescription = [text]

        case (.groupedParameterStart, .groupedParametersHeader),
             (.groupedParameterStart, .words):
            continue
        case (.groupedParameterStart, .groupedParameter(_, let name, _, let text)):
            state = .groupedParameter
            parameterName = name
            runningDescription = [text]
        case (.groupedParameterStart, .parameter(_, _, let name, _, let text)):
            state = .groupedParameter
            parameterName = name
            runningDescription = [text]
        case (.groupedParameterStart, .returns(_, _, _, let text)):
            state = .returns
            runningDescription = [text]
        case (.groupedParameterStart, .throws(_, _, _, let text)):
            state = .throws
            runningDescription = [text]

        case (.groupedParameter, .groupedParametersHeader(_, let text)):
            runningDescription.append(text)
        case (.groupedParameter, .groupedParameter(_, let name, _, let text)):
            concludeParamater()
            parameterName = name
            runningDescription = [text]
        case (.groupedParameter, .parameter(_, _, let name, _, let text)):
            concludeParamater()
            parameterName = name
            runningDescription = [text]
        case (.groupedParameter, .returns(_, _, _, let text)):
            concludeParamater()
            state = .returns
            runningDescription = [text]
        case (.groupedParameter, .throws(_, _, _, let text)):
            concludeParamater()
            state = .throws
            runningDescription = [text]

        case (.returns, .groupedParametersHeader(_, let text)):
            runningDescription.append(text)
        case (.returns, .groupedParameter(_, _ , _, let text)):
            runningDescription.append(text)
        case (.returns, .parameter(_, _, let name, _, let text)):
            returnDescription = runningDescription
            state = .separateParameter
            parameterName = name
            runningDescription = [text]
        case (.returns, .returns(_, _, _, let text)):
            runningDescription.append(text)
        case (.returns, .throws(_, _, _, let text)):
            returnDescription = runningDescription
            state = .throws
            runningDescription = [text]

        case (.throws, .groupedParametersHeader(_, let text)):
            runningDescription.append(text)
        case (.throws, .groupedParameter(_, _ , _, let text)):
            runningDescription.append(text)
        case (.throws, .parameter(_, _, let name, _, let text)):
            throwDescription = runningDescription
            state = .separateParameter
            parameterName = name
            runningDescription = [text]
        case (.throws, .throws(_, _, _, let text)):
            runningDescription.append(text)
        case (.throws, .returns(_, _, _, let text)):
            throwDescription = runningDescription
            state = .returns
            runningDescription = [text]

        case (_, .words(let newWords)):
            runningDescription.append(newWords)
        }
    }

    // wrap up for last state
    switch state {
    case .start, .groupedParameterStart:
        break
    case .description:
        topLevelDescription = runningDescription
    case .groupedParameter, .separateParameter:
        concludeParamater()
    case .returns:
        returnDescription = runningDescription
    case .throws:
        throwDescription = runningDescription
    }

    return DocString(
        description: topLevelDescription,
        parameters: parameters,
        returns: returnDescription,
        throws: throwDescription
    )
}
