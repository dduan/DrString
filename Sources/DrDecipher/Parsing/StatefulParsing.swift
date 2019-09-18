public func parse(lines: [String]) throws -> DocString {
    assert(!lines.isEmpty)
    guard
        let firstLine = lines.first,
        let _ = firstLine.firstIndex(where: { !isBlank($0) })
        else
    {
        throw Parsing.StructuralError.invalidStart
    }

    var topLevelDescription = [String]()
    var returnDescription = [String]()
    var throwDescription = [String]()
    var runningDescription = [String]()
    var parameterName = ""
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
        case (.start, .groupedParameter(_, _, let text)):
            state = .description
            runningDescription = [text]
        case (.start, .parameter(let name, let text)):
            state = .separateParameter
            parameterName = name
            runningDescription = [text]
        case (.start, .returns(let text)):
            state = .returns
            runningDescription = [text]
        case (.start, .throws(let text)):
            state = .throws
            runningDescription = [text]

        case (.description, .groupedParametersHeader):
            state = .groupedParameterStart
            topLevelDescription = runningDescription
            runningDescription = []
        case (.description, .groupedParameter(_, _, let rawText)):
            runningDescription.append(rawText)
        case (.description, .parameter(let name, let text)):
            topLevelDescription = runningDescription
            state = .separateParameter
            runningDescription = [text]
            parameterName = name
        case (.description, .returns(let text)):
            topLevelDescription = runningDescription
            state = .returns
            runningDescription = [text]
        case (.description, .throws(let text)):
            topLevelDescription = runningDescription
            state = .throws
            runningDescription = [text]

        case (.separateParameter, .groupedParametersHeader):
            concludeParamater()
            state = .groupedParameterStart
            runningDescription = []
        case (.separateParameter, .groupedParameter(_, _, let rawText)):
            runningDescription.append(rawText)
        case (.separateParameter, .parameter(let name, let text)):
            concludeParamater()
            parameterName = name
            runningDescription = [text]
        case (.separateParameter, .returns(let text)):
            concludeParamater()
            state = .returns
            runningDescription = [text]
        case (.separateParameter, .throws(let text)):
            concludeParamater()
            state = .throws
            runningDescription = [text]

        case (.groupedParameterStart, .groupedParametersHeader),
             (.groupedParameterStart, .words):
            continue
        case (.groupedParameterStart, .groupedParameter(let name, let text, _)):
            state = .groupedParameter
            parameterName = name
            runningDescription = [text]
        case (.groupedParameterStart, .parameter(let name, let text)):
            state = .groupedParameter
            parameterName = name
            runningDescription = [text]
        case (.groupedParameterStart, .returns(let text)):
            state = .returns
            runningDescription = [text]
        case (.groupedParameterStart, .throws(let text)):
            state = .throws
            runningDescription = [text]

        case (.groupedParameter, .groupedParametersHeader(let text)):
            runningDescription.append(text)
        case (.groupedParameter, .groupedParameter(let name, let text, _)):
            concludeParamater()
            parameterName = name
            runningDescription = [text]
        case (.groupedParameter, .parameter(let name, let text)):
            concludeParamater()
            parameterName = name
            runningDescription = [text]
        case (.groupedParameter, .returns(let text)):
            concludeParamater()
            state = .returns
            runningDescription = [text]
        case (.groupedParameter, .throws(let text)):
            concludeParamater()
            state = .throws
            runningDescription = [text]

        case (.returns, .groupedParametersHeader(let text)):
            runningDescription.append(text)
        case (.returns, .groupedParameter(_, _, let text)):
            runningDescription.append(text)
        case (.returns, .parameter(let name, let text)):
            returnDescription = runningDescription
            state = .separateParameter
            parameterName = name
            runningDescription = [text]
        case (.returns, .returns(let text)):
            runningDescription.append(text)
        case (.returns, .throws(let text)):
            returnDescription = runningDescription
            state = .throws
            runningDescription = [text]

        case (.throws, .groupedParametersHeader(let text)):
            runningDescription.append(text)
        case (.throws, .groupedParameter(_, _, let text)):
            runningDescription.append(text)
        case (.throws, .parameter(let name, let text)):
            throwDescription = runningDescription
            state = .separateParameter
            parameterName = name
            runningDescription = [text]
        case (.throws, .throws(let text)):
            runningDescription.append(text)
        case (.throws, .returns(let text)):
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
