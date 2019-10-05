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
    var returnsMeta: (String, TextLeadByWhitespace, String)? = nil
    var throwsMeta: (String, TextLeadByWhitespace, String)? = nil
    var parameterName: (String, TextLeadByWhitespace?, TextLeadByWhitespace, String) = ("", nil, .empty, "")
    var parameters = [DocString.Entry]()
    var state = Parsing.State.start
    var parameterHeader: DocString.Entry?

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
        case (.start, .groupedParametersHeader(let preDash, let keyword, let preColon, let text)):
            state = .groupedParameterStart
            parameterHeader = .init(
                preDashWhitespaces: preDash,
                keyword: keyword,
                name: .init("", ""),
                preColonWhitespace: preColon,
                description: text.lead.isEmpty && text.text.isEmpty ? [] : [text]
            )
        case (.start, let .groupedParameter(preDash, name, preColon, text)):
            state = .description
            runningDescription = [.init(preDash, "-\(name)\(preColon):\(text)")]
        case (.start, let .parameter(preDash, keyword, name, preColon, text)):
            state = .separateParameter
            parameterName = (preDash, keyword, name, preColon)
            runningDescription = [text]
        case (.start, let .returns(preDash, keyword, preColon, text)):
            state = .returns
            returnsMeta = (preDash, keyword, preColon)
            runningDescription = [text]
        case (.start, let .throws(preDash, keyword, preColon, text)):
            state = .throws
            throwsMeta = (preDash, keyword, preColon)
            runningDescription = [text]

        case (.description, .groupedParametersHeader(let preDash, let keyword, let preColon, let text)):
            state = .groupedParameterStart
            parameterHeader = .init(
                preDashWhitespaces: preDash,
                keyword: keyword,
                name: .init("", ""),
                preColonWhitespace: preColon,
                description: text.lead.isEmpty && text.text.isEmpty ? [] : [text]
            )
            topLevelDescription = runningDescription
            runningDescription = []
        case (.description, let .groupedParameter(preDash, name, preColon, text)):
            runningDescription.append(.init(preDash, "-\(name)\(preColon):\(text)"))
        case (.description, let .parameter(preDash, keyword, name, preColon, text)):
            topLevelDescription = runningDescription
            state = .separateParameter
            runningDescription = [text]
            parameterName = (preDash, keyword, name, preColon)
        case (.description, let .returns(preDash, keyword, preColon, text)):
            topLevelDescription = runningDescription
            state = .returns
            returnsMeta = (preDash, keyword, preColon)
            runningDescription = [text]
        case (.description, let .throws(preDash, keyword, preColon, text)):
            topLevelDescription = runningDescription
            state = .throws
            throwsMeta = (preDash, keyword, preColon)
            runningDescription = [text]

        case (.separateParameter, .groupedParametersHeader(let preDash, let keyword, let preColon, let text)):
            concludeParamater()
            state = .groupedParameterStart
            parameterHeader = .init(
                preDashWhitespaces: preDash,
                keyword: keyword,
                name: .init("", ""),
                preColonWhitespace: preColon,
                description: text.lead.isEmpty && text.text.isEmpty ? [] : [text]
            )
            runningDescription = []
        case (.separateParameter, let .groupedParameter(preDash, name, preColon, text)):
            runningDescription.append(.init(preDash, "-\(name)\(preColon):\(text)"))
        case (.separateParameter, let .parameter(preDash, keyword, name, preColon, text)):
            concludeParamater()
            parameterName = (preDash, keyword, name, preColon)
            runningDescription = [text]
        case (.separateParameter, let .returns(preDash, keyword, preColon, text)):
            concludeParamater()
            state = .returns
            returnsMeta = (preDash, keyword, preColon)
            runningDescription = [text]
        case (.separateParameter, let .throws(preDash, keyword, preColon, text)):
            concludeParamater()
            state = .throws
            throwsMeta = (preDash, keyword, preColon)
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
        case (.groupedParameterStart, let .returns(preDash, keyword, preColon, text)):
            state = .returns
            returnsMeta = (preDash, keyword, preColon)
            runningDescription = [text]
        case (.groupedParameterStart, let .throws(preDash, keyword, preColon, text)):
            state = .throws
            throwsMeta = (preDash, keyword, preColon)
            runningDescription = [text]

        case (.groupedParameter, .groupedParametersHeader(let preDash, let keyword, let preColon, let text)):
            let text = TextLeadByWhitespace(preDash, "-\(keyword)\(preColon):\(text)")
            runningDescription.append(text)
        case (.groupedParameter, let .groupedParameter(preDash, name, preColon, text)):
            concludeParamater()
            parameterName = (preDash, nil, name, preColon)
            runningDescription = [text]
        case (.groupedParameter, let .parameter(preDash, keyword, name, preColon, text)):
            concludeParamater()
            parameterName = (preDash, keyword, name, preColon)
            runningDescription = [text]
        case (.groupedParameter, let .returns(preDash, keyword, preColon, text)):
            concludeParamater()
            state = .returns
            returnsMeta = (preDash, keyword, preColon)
            runningDescription = [text]
        case (.groupedParameter, let .throws(preDash, keyword, preColon, text)):
            concludeParamater()
            state = .throws
            throwsMeta = (preDash, keyword, preColon)
            runningDescription = [text]

        case (.returns, .groupedParametersHeader(let preDash, let keyword, let preColon, let text)):
            let text = TextLeadByWhitespace(preDash, "-\(keyword)\(preColon):\(text)")
            runningDescription.append(text)
        case (.returns, let .groupedParameter(preDash, name, preColon, text)):
            runningDescription.append(.init(preDash, "-\(name)\(preColon):\(text)"))
        case (.returns, let .parameter(preDash, keyword, name, preColon, text)):
            returnDescription = runningDescription
            state = .separateParameter
            parameterName = (preDash, keyword, name, preColon)
            runningDescription = [text]
        case (.returns, let .returns(preDash, keyword, preColon, text)):
            runningDescription.append(.init(preDash, "-\(keyword)\(preColon):\(text)"))
        case (.returns, let .throws(preDash, keyword, preColon, text)):
            returnDescription = runningDescription
            state = .throws
            throwsMeta = (preDash, keyword, preColon)
            runningDescription = [text]

        case (.throws, .groupedParametersHeader(let preDash, let keyword, let preColon, let text)):
            let text = TextLeadByWhitespace(preDash, "-\(keyword)\(preColon):\(text)")
            runningDescription.append(text)
        case (.throws, let .groupedParameter(preDash, name, preColon, text)):
            runningDescription.append(.init(preDash, "-\(name)\(preColon):\(text)"))
        case (.throws, let .parameter(preDash, keyword, name, preColon, text)):
            throwDescription = runningDescription
            state = .separateParameter
            parameterName = (preDash, keyword, name, preColon)
            runningDescription = [text]
        case (.throws, let .throws(preDash, keyword, preColon, text)):
            runningDescription.append(.init(preDash, "-\(keyword)\(preColon):\(text)"))
        case (.throws, let .returns(preDash, keyword, preColon, text)):
            throwDescription = runningDescription
            state = .returns
            returnsMeta = (preDash, keyword, preColon)
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
        parameterHeader: parameterHeader,
        parameters: parameters,
        returns: returnsMeta.map { (preDash, keyword, preColon) in
            return .init(
                preDashWhitespaces: preDash,
                keyword: keyword,
                name: .empty,
                preColonWhitespace: preColon,
                description: returnDescription
            )
        },
        throws: throwsMeta.map { (preDash, keyword, preColon) in
            return .init(
                preDashWhitespaces: preDash,
                keyword: keyword,
                name: .empty,
                preColonWhitespace: preColon,
                description: throwDescription
            )
        }
    )
}
