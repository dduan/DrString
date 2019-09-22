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
    var parameterName: (String, TextLeadByWhitespace?, TextLeadByWhitespace, String) = ("", nil, .empty, "")
    var parameters = [DocString.Entry]()
    var state = Parsing.State.start

    func concludeParamater() {
        parameters.append(.init(
            preDashWhitespaces: parameterName.0,
            keyword: parameterName.1,
            name: parameterName.2,
            preColonWhitespace: parameterName.3,
            description: runningDescription
        ))
    }

    for line in lines {
        let parsed = try parse(line: line)
        switch (state, parsed) {
        case (.start, .words(let newWords)):
            state = .description
            runningDescription = [newWords]
        case (.start, .groupedParametersHeader):
            state = .groupedParameterStart
        case (.start, let .groupedParameter(preDash, name, preColon, text)):
            state = .description
            runningDescription = [.init(preDash, "-\(name)\(preColon):\(text)")]
        case (.start, let .parameter(preDash, keyword, name, preColon, text)):
            state = .separateParameter
            parameterName = (preDash, keyword, name, preColon)
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
        case (.description, let .groupedParameter(preDash, name, preColon, text)):
            runningDescription.append(.init(preDash, "-\(name)\(preColon):\(text)"))
        case (.description, let .parameter(preDash, keyword, name, preColon, text)):
            topLevelDescription = runningDescription
            state = .separateParameter
            runningDescription = [text]
            parameterName = (preDash, keyword, name, preColon)
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
        case (.separateParameter, let .groupedParameter(preDash, name, preColon, text)):
            runningDescription.append(.init(preDash, "-\(name)\(preColon):\(text)"))
        case (.separateParameter, let .parameter(preDash, keyword, name, preColon, text)):
            concludeParamater()
            parameterName = (preDash, keyword, name, preColon)
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
        case (.groupedParameterStart, let .groupedParameter(preDash, name, preColon, text)):
            state = .groupedParameter
            parameterName = (preDash, nil, name, preColon)
            runningDescription = [text]
        case (.groupedParameterStart, let .parameter(preDash, keyword, name, preColon, text)):
            state = .groupedParameter
            parameterName = (preDash, keyword, name, preColon)
            runningDescription = [text]
        case (.groupedParameterStart, .returns(_, _, _, let text)):
            state = .returns
            runningDescription = [text]
        case (.groupedParameterStart, .throws(_, _, _, let text)):
            state = .throws
            runningDescription = [text]

        case (.groupedParameter, .groupedParametersHeader(_, let text)):
            runningDescription.append(text)
        case (.groupedParameter, let .groupedParameter(preDash, name, preColon, text)):
            concludeParamater()
            parameterName = (preDash, nil, name, preColon)
            runningDescription = [text]
        case (.groupedParameter, let .parameter(preDash, keyword, name, preColon, text)):
            concludeParamater()
            parameterName = (preDash, keyword, name, preColon)
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
        case (.returns, let .groupedParameter(preDash, name, preColon, text)):
            runningDescription.append(.init(preDash, "-\(name)\(preColon):\(text)"))
        case (.returns, let .parameter(preDash, keyword, name, preColon, text)):
            returnDescription = runningDescription
            state = .separateParameter
            parameterName = (preDash, keyword, name, preColon)
            runningDescription = [text]
        case (.returns, .returns(_, _, _, let text)):
            runningDescription.append(text)
        case (.returns, .throws(_, _, _, let text)):
            returnDescription = runningDescription
            state = .throws
            runningDescription = [text]

        case (.throws, .groupedParametersHeader(_, let text)):
            runningDescription.append(text)
        case (.throws, let .groupedParameter(preDash, name, preColon, text)):
            runningDescription.append(.init(preDash, "-\(name)\(preColon):\(text)"))
        case (.throws, let .parameter(preDash, keyword, name, preColon, text)):
            throwDescription = runningDescription
            state = .separateParameter
            parameterName = (preDash, keyword, name, preColon)
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
