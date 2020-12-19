import Models

public func parse(location: AbsoluteSourceLocation, lines: [String]) throws -> DocString {
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
    var returnsMeta: (Int, String, TextLeadByWhitespace, String, Bool)? = nil
    var throwsMeta: (Int, String, TextLeadByWhitespace, String, Bool)? = nil
    var parameterName: (String, TextLeadByWhitespace?, TextLeadByWhitespace, String, Bool) = ("", nil, .empty, "", true)
    var parameters = [DocString.Entry]()
    var state = Parsing.State.start
    var parameterHeader: DocString.Entry?

    func concludeParameter(lineNumber: Int) {
        parameters.append(.init(
            relativeLineNumber: lineNumber - runningDescription.count,
            preDashWhitespaces: parameterName.0,
            keyword: parameterName.1,
            name: parameterName.2,
            preColonWhitespace: parameterName.3,
            hasColon: parameterName.4,
            description: runningDescription
        ))
    }

    for (lineNumber, line) in zip(0..., lines) {
        let parsed = try parse(line: line)
        switch (state, parsed) {
        case (.start, .words(let newWords)):
            state = .description
            runningDescription = [newWords]
        case (.start, .groupedParametersHeader(let preDash, let keyword, let preColon, let hasColon, let text)):
            state = .groupedParameterStart
            parameterHeader = .init(
                relativeLineNumber: lineNumber,
                preDashWhitespaces: preDash,
                keyword: keyword,
                name: .init("", ""),
                preColonWhitespace: preColon,
                hasColon: hasColon,
                description: text.lead.isEmpty && text.text.isEmpty ? [] : [text]
            )
        case (.start, let .groupedParameter(preDash, name, preColon, hasColon, text)):
            state = .description
            runningDescription = [.init(preDash, "-\(name)\(preColon)\(hasColon ? ":" : "")\(text)")]
        case (.start, let .parameter(preDash, keyword, name, preColon, hasColon, text)):
            state = .separateParameter
            parameterName = (preDash, keyword, name, preColon, hasColon)
            runningDescription = [text]
        case (.start, let .returns(preDash, keyword, preColon, hasColon, text)):
            state = .returns
            returnsMeta = (lineNumber, preDash, keyword, preColon, hasColon)
            runningDescription = [text]
        case (.start, let .throws(preDash, keyword, preColon, hasColon, text)):
            state = .throws
            throwsMeta = (lineNumber, preDash, keyword, preColon, hasColon)
            runningDescription = [text]

        case (.description, .groupedParametersHeader(let preDash, let keyword, let preColon, let hasColon, let text)):
            state = .groupedParameterStart
            parameterHeader = .init(
                relativeLineNumber: lineNumber,
                preDashWhitespaces: preDash,
                keyword: keyword,
                name: .init("", ""),
                preColonWhitespace: preColon,
                hasColon: hasColon,
                description: text.lead.isEmpty && text.text.isEmpty ? [] : [text]
            )
            topLevelDescription = runningDescription
            runningDescription = []
        case (.description, let .groupedParameter(preDash, name, preColon, hasColon, text)):
            runningDescription.append(.init(preDash, "-\(name)\(preColon)\(hasColon ? ":" : "")\(text)"))
        case (.description, let .parameter(preDash, keyword, name, preColon, hasColon, text)):
            topLevelDescription = runningDescription
            state = .separateParameter
            runningDescription = [text]
            parameterName = (preDash, keyword, name, preColon, hasColon)
        case (.description, let .returns(preDash, keyword, preColon, hasColon, text)):
            topLevelDescription = runningDescription
            state = .returns
            returnsMeta = (lineNumber, preDash, keyword, preColon, hasColon)
            runningDescription = [text]
        case (.description, let .throws(preDash, keyword, preColon, hasColon, text)):
            topLevelDescription = runningDescription
            state = .throws
            throwsMeta = (lineNumber, preDash, keyword, preColon, hasColon)
            runningDescription = [text]

        case (.separateParameter, .groupedParametersHeader(let preDash, let keyword, let preColon, let hasColon, let text)):
            concludeParameter(lineNumber: lineNumber)
            state = .groupedParameterStart
            parameterHeader = .init(
                relativeLineNumber: lineNumber,
                preDashWhitespaces: preDash,
                keyword: keyword,
                name: .init("", ""),
                preColonWhitespace: preColon,
                hasColon: hasColon,
                description: text.lead.isEmpty && text.text.isEmpty ? [] : [text]
            )
            runningDescription = []
        case (.separateParameter, let .groupedParameter(preDash, name, preColon, hasColon, text)):
            runningDescription.append(.init(preDash, "-\(name)\(preColon)\(hasColon ? ":" : "")\(text)"))
        case (.separateParameter, let .parameter(preDash, keyword, name, preColon, hasColon, text)):
            concludeParameter(lineNumber: lineNumber)
            parameterName = (preDash, keyword, name, preColon, hasColon)
            runningDescription = [text]
        case (.separateParameter, let .returns(preDash, keyword, preColon, hasColon, text)):
            concludeParameter(lineNumber: lineNumber)
            state = .returns
            returnsMeta = (lineNumber, preDash, keyword, preColon, hasColon)
            runningDescription = [text]
        case (.separateParameter, let .throws(preDash, keyword, preColon, hasColon, text)):
            concludeParameter(lineNumber: lineNumber)
            state = .throws
            throwsMeta = (lineNumber, preDash, keyword, preColon, hasColon)
            runningDescription = [text]

        case (.groupedParameterStart, .groupedParametersHeader),
             (.groupedParameterStart, .words):
            continue
        case (.groupedParameterStart, let .groupedParameter(preDash, name, preColon, hasColon, text)):
            state = .groupedParameter
            parameterName = (preDash, nil, name, preColon, hasColon)
            runningDescription = [text]
        case (.groupedParameterStart, let .parameter(preDash, keyword, name, preColon, hasColon, text)):
            state = .groupedParameter
            parameterName = (preDash, keyword, name, preColon, hasColon)
            runningDescription = [text]
        case (.groupedParameterStart, let .returns(preDash, keyword, preColon, hasColon, text)):
            state = .returns
            returnsMeta = (lineNumber, preDash, keyword, preColon, hasColon)
            runningDescription = [text]
        case (.groupedParameterStart, let .throws(preDash, keyword, preColon, hasColon, text)):
            state = .throws
            throwsMeta = (lineNumber, preDash, keyword, preColon, hasColon)
            runningDescription = [text]

        case (.groupedParameter, .groupedParametersHeader(let preDash, let keyword, let preColon, let hasColon, let text)):
            let text = TextLeadByWhitespace(preDash, "-\(keyword)\(preColon)\(hasColon ? ":" : "")\(text)")
            runningDescription.append(text)
        case (.groupedParameter, let .groupedParameter(preDash, name, preColon, hasColon, text)):
            concludeParameter(lineNumber: lineNumber)
            parameterName = (preDash, nil, name, preColon, hasColon)
            runningDescription = [text]
        case (.groupedParameter, let .parameter(preDash, keyword, name, preColon, hasColon, text)):
            concludeParameter(lineNumber: lineNumber)
            parameterName = (preDash, keyword, name, preColon, hasColon)
            runningDescription = [text]
        case (.groupedParameter, let .returns(preDash, keyword, preColon, hasColon, text)):
            concludeParameter(lineNumber: lineNumber)
            state = .returns
            returnsMeta = (lineNumber, preDash, keyword, preColon, hasColon)
            runningDescription = [text]
        case (.groupedParameter, let .throws(preDash, keyword, preColon, hasColon, text)):
            concludeParameter(lineNumber: lineNumber)
            state = .throws
            throwsMeta = (lineNumber, preDash, keyword, preColon, hasColon)
            runningDescription = [text]

        case (.returns, .groupedParametersHeader(let preDash, let keyword, let preColon, let hasColon, let text)):
            let text = TextLeadByWhitespace(preDash, "-\(keyword)\(preColon)\(hasColon ? ":" : "")\(text)")
            runningDescription.append(text)
        case (.returns, let .groupedParameter(preDash, name, preColon, hasColon, text)):
            runningDescription.append(.init(preDash, "-\(name)\(preColon)\(hasColon ? ":" : "")\(text)"))
        case (.returns, let .parameter(preDash, keyword, name, preColon, hasColon, text)):
            returnDescription = runningDescription
            state = .separateParameter
            parameterName = (preDash, keyword, name, preColon, hasColon)
            runningDescription = [text]
        case (.returns, let .returns(preDash, keyword, preColon, hasColon, text)):
            runningDescription.append(.init(preDash, "-\(keyword)\(preColon)\(hasColon ? ":" : "")\(text)"))
        case (.returns, let .throws(preDash, keyword, preColon, hasColon, text)):
            returnDescription = runningDescription
            state = .throws
            throwsMeta = (lineNumber, preDash, keyword, preColon, hasColon)
            runningDescription = [text]

        case (.throws, .groupedParametersHeader(let preDash, let keyword, let preColon, let hasColon, let text)):
            let text = TextLeadByWhitespace(preDash, "-\(keyword)\(preColon)\(hasColon ? ":" : "")\(text)")
            runningDescription.append(text)
        case (.throws, let .groupedParameter(preDash, name, preColon, hasColon, text)):
            runningDescription.append(.init(preDash, "-\(name)\(preColon)\(hasColon ? ":" : "")\(text)"))
        case (.throws, let .parameter(preDash, keyword, name, preColon, hasColon, text)):
            throwDescription = runningDescription
            state = .separateParameter
            parameterName = (preDash, keyword, name, preColon, hasColon)
            runningDescription = [text]
        case (.throws, let .throws(preDash, keyword, preColon, hasColon, text)):
            runningDescription.append(.init(preDash, "-\(keyword)\(preColon)\(hasColon ? ":" : "")\(text)"))
        case (.throws, let .returns(preDash, keyword, preColon, hasColon, text)):
            throwDescription = runningDescription
            state = .returns
            returnsMeta = (lineNumber, preDash, keyword, preColon, hasColon)
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
        concludeParameter(lineNumber: lines.count)
    case .returns:
        returnDescription = runningDescription
    case .throws:
        throwDescription = runningDescription
    }

    return DocString(
        location: location,
        description: topLevelDescription,
        parameterHeader: parameterHeader,
        parameters: parameters,
        returns: returnsMeta.map { (lineNumber, preDash, keyword, preColon, hasColon) in
            return .init(
                relativeLineNumber: lineNumber,
                preDashWhitespaces: preDash,
                keyword: keyword,
                name: .empty,
                preColonWhitespace: preColon,
                hasColon: hasColon,
                description: returnDescription
            )
        },
        throws: throwsMeta.map { (lineNumber, preDash, keyword, preColon, hasColon) in
            return .init(
                relativeLineNumber: lineNumber,
                preDashWhitespaces: preDash,
                keyword: keyword,
                name: .empty,
                preColonWhitespace: preColon,
                hasColon: hasColon,
                description: throwDescription
            )
        }
    )
}
