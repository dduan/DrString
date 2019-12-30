import Decipher
import Crawler

extension Documentable {
    public func validate(ignoreThrows: Bool, ignoreReturns: Bool, firstLetterUpper: Bool,
                         needsSeparation: [Section], verticalAlign: Bool, parameterStyle: ParameterStyle,
                         alignAfterColon: [Section])
        throws -> DocProblem?
    {
        guard !self.docLines.isEmpty, let docs = try? parse(lines: self.docLines) else {
            return nil
        }

        switch self.details {
        case let .function(doesThrow, returnType, parameters):
            let details = try findDescriptionProblems(
                docs, needsSeparator: needsSeparation.contains(.description))
                + findParameterProblems(parameters, docs, firstLetterUpper,
                                        needsSeparation: needsSeparation.contains(.parameters),
                                        verticalAlign: verticalAlign, style: parameterStyle,
                                        alignAfterColon: alignAfterColon.contains(.parameters))
                + findThrowsProblems(ignoreThrows: ignoreThrows, doesThrow: doesThrow, docs,
                                     firstLetterUpper: firstLetterUpper,
                                     needsSeparation: needsSeparation.contains(.throws),
                                     alignAfterColon: alignAfterColon.contains(.throws))
                + findReturnsProblems(ignoreReturns: ignoreReturns, docs, returnType: returnType,
                                      firstLetterUpper: firstLetterUpper,
                                      alignAfterColon: alignAfterColon.contains(.throws))

            if details.isEmpty {
                return nil
            }

            return DocProblem(
                docName: self.name,
                filePath: self.path,
                line: self.line,
                column: self.column,
                details: details
            )
        default:
            return nil
        }
    }
}

func findDescriptionProblems(_ docs: DocString, needsSeparator: Bool) -> [DocProblem.Detail] {
    var result = [DocProblem.Detail]()
    if needsSeparator, !docs.parameters.isEmpty ||
        docs.throws != nil ||
        docs.returns != nil, let last = docs.description.last, !last.lead.isEmpty ||
        !last.text.isEmpty
    {
        result.append(.descriptionShouldEndWithEmptyLine)
    }

    return result
}

func findReturnsProblems(ignoreReturns: Bool, _ docs: DocString, returnType: String?,
                         firstLetterUpper: Bool, alignAfterColon: Bool)
    -> [DocProblem.Detail]
{
    guard let returnType = returnType else {
        if let returnsKeyword = docs.returns?.keyword?.text {
            return [.redundantKeyword(returnsKeyword)]
        } else {
            return []
        }
    }

    guard let returnsDoc = docs.returns else {
        return ignoreReturns ? [] : [.missingReturn(returnType)]
    }

    let keywordText = returnsDoc.keyword?.text ?? ((firstLetterUpper ? "R" : "r") + "eturns")
    var result = [DocProblem.Detail]()

    if returnsDoc.preDashWhitespace != " " {
        result.append(.preDashSpace(keywordText, returnsDoc.preDashWhitespace))
    }

    if let preKeyword = returnsDoc.keyword?.lead, preKeyword != " " {
        result.append(.spaceBetweenDashAndKeyword(keywordText, preKeyword))
    }

    if returnsDoc.preColonWhitespace != "" {
        result.append(.spaceBeforeColon(returnsDoc.preColonWhitespace, keywordText))
    }

    let expectedKeyword = firstLetterUpper ? "Returns" : "returns"

    if !returnsDoc.hasColon {
        result.append(.missingColon(expectedKeyword))
    }

    if let postColonLead = returnsDoc.description.first?.lead, postColonLead != " " {
        result.append(.spaceAfterColon(keywordText, postColonLead))
    }

    if alignAfterColon {
        let standardPaddingLength = 12
        let standardPadding = String(Array(repeating: " ", count: standardPaddingLength))
        for (index, line) in returnsDoc.description.dropFirst().enumerated() {
            if line.lead < standardPadding {
                result.append(.verticalAlignment(standardPaddingLength, keywordText, index + 2))
            }
        }
    }

    if let keyword = returnsDoc.keyword?.text, keyword != expectedKeyword {
        result.append(.keywordCasing(keyword, expectedKeyword))
    }

    return result
}

func findThrowsProblems(ignoreThrows: Bool, doesThrow: Bool, _ docs: DocString, firstLetterUpper: Bool,
                        needsSeparation: Bool, alignAfterColon: Bool) -> [DocProblem.Detail]
{
    if !doesThrow {
        if let throwsKeyword = docs.throws?.keyword?.text {
            return [.redundantKeyword(throwsKeyword)]
        } else {
            return []
        }
    }

    guard let throwsDoc = docs.throws else {
        return ignoreThrows ? [] : [.missingThrow]
    }

    let keywordText = throwsDoc.keyword?.text ?? ((firstLetterUpper ? "T" : "t") + "hrows")
    var result = [DocProblem.Detail]()

    if throwsDoc.preDashWhitespace != " " {
        result.append(.preDashSpace("throws", throwsDoc.preDashWhitespace))
    }

    if let preKeyword = throwsDoc.keyword?.lead, preKeyword != " " {
        result.append(.spaceBetweenDashAndKeyword(keywordText, preKeyword))
    }

    if throwsDoc.preColonWhitespace != "" {
        result.append(.spaceBeforeColon(throwsDoc.preColonWhitespace, keywordText))
    }

    let expectedKeyword = firstLetterUpper ? "Throws" : "throws"

    if !throwsDoc.hasColon {
        result.append(.missingColon(expectedKeyword))
    }

    if let postColonLead = throwsDoc.description.first?.lead, postColonLead != " " {
        result.append(.spaceAfterColon(keywordText, postColonLead))
    }

    if alignAfterColon {
        let standardPaddingLength = 11
        let standardPadding = String(Array(repeating: " ", count: standardPaddingLength))
        for (index, line) in throwsDoc.description.dropFirst().enumerated() {
            if line.lead < standardPadding {
                result.append(.verticalAlignment(standardPaddingLength, keywordText, index + 2))
            }
        }
    }

    if let keyword = throwsDoc.keyword?.text, keyword != expectedKeyword {
        result.append(.keywordCasing(keyword, expectedKeyword))
    }

    if needsSeparation, docs.returns != nil, let last = throwsDoc.description.last, !last.lead.isEmpty ||
        !last.text.isEmpty
    {
        let backupKeyword = firstLetterUpper ? "Throws" : "throws"
        result.append(.sectionShouldEndWithEmptyLine(throwsDoc.keyword?.text ?? backupKeyword))
    }

    return result
}

func findParameterProblems(_ parameters: [Parameter], _ docs: DocString, _ firstLetterUpper: Bool,
                           needsSeparation: Bool, verticalAlign: Bool, style: ParameterStyle,
                           alignAfterColon: Bool) throws
    -> [DocProblem.Detail]
{
    var result = [DocProblem.Detail]()

    if let header = docs.parameterHeader, let keyword = header.keyword {
        if header.preDashWhitespace != " " {
            result.append(.preDashSpace(keyword.text, header.preDashWhitespace))
        }

        if keyword.lead != " " {
            result.append(.spaceBetweenDashAndKeyword(keyword.text, keyword.lead))
        }

        if !header.preColonWhitespace.isEmpty {
            result.append(.spaceBeforeColon(header.preColonWhitespace, keyword.text))
        }

        let expectedKeyword = firstLetterUpper ? "Parameters" : "parameters"
        if keyword.text != expectedKeyword {
            result.append(.keywordCasing(keyword.text, expectedKeyword))
        }

        if !header.hasColon {
            result.append(.missingColon(expectedKeyword))
        }

        if !header.description.isEmpty {
            result.append(.redundantTextFollowingParameterHeader(keyword.text))
        }

        if style == .separate {
            result.append(.parametersAreNotSeparated)
        }
    } else if docs.parameterHeader == nil, style == .grouped, docs.parameters.count > 1 {
        result.append(.parametersAreNotGrouped)
    }

    // 1. find longest common sequence between the signature and docstring
    let commonality = commonSequence(parameters, docs)

    // 2. items that are in the signature but not in the common sequence are missing
    var commonIter = commonality.makeIterator()
    var nextCommon = commonIter.next()
    for param in parameters {
        if param == nextCommon {
            nextCommon = commonIter.next()
        } else {
            result.append(.missingParameter(param.name, param.type))
        }
    }

    // 3. items that are in the docstring but not in the common sequence are redundant
    commonIter = commonality.makeIterator()
    nextCommon = commonIter.next()
    var validDocs = [DocString.Entry]()
    var maxNameLength = 0
    for docParam in docs.parameters {
        if docParam.name.text == nextCommon?.name {
            validDocs.append(docParam)
            if docParam.name.text.count > maxNameLength {
                maxNameLength = docParam.name.text.count
            }
            nextCommon = commonIter.next()
        } else {
            result.append(.redundantParameter(docParam.name.text))
        }
    }

    // 4. Only consider other issues if a parameter is in the common sequence
    for docParam in validDocs {
        result += findDocParameterFormatProblems(docParam, maxNameLength, firstLetterUpper, verticalAlign,
                                                 alignAfterColon: alignAfterColon)
    }

    if needsSeparation, docs.returns != nil || docs.throws != nil, let lastParam = docs.parameters.last,
        let last = lastParam.description.last, !last.lead.isEmpty || !last.text.isEmpty
    {
        result.append(.sectionShouldEndWithEmptyLine(lastParam.name.text))
    }

    return result
}

func findDocParameterFormatProblems(_ parameter: DocString.Entry, _ maxPeerNameLength: Int,
                                    _ firstLetterUpper: Bool, _ verticalAlign: Bool, alignAfterColon: Bool)
    -> [DocProblem.Detail]
{
    var result = [DocProblem.Detail]()

    if let keyword = parameter.keyword {
        if parameter.preDashWhitespace != " " {
            result.append(.preDashSpaceInParameter(1, parameter.preDashWhitespace, parameter.name.text))
        }

        if keyword.lead != " " {
            result.append(
                .spaceBetweenDashAndParameterKeyword(keyword.lead, keyword.text, parameter.name.text))
        }

        if parameter.name.lead != " " {
            result.append(.spaceBeforeParameterName(parameter.name.lead, keyword.text, parameter.name.text))
        }
    } else if parameter.preDashWhitespace != "   " {
        result.append(.preDashSpaceInParameter(3, parameter.preDashWhitespace, parameter.name.text))
    }

    if parameter.preColonWhitespace != "" {
        result.append(.spaceBeforeColon(parameter.preColonWhitespace, parameter.name.text))
    }

    if !parameter.hasColon {
        result.append(.missingColon(parameter.name.text))
    }

    if verticalAlign {
        // Vertical alignment
        // Knowing the longest name's length among peers, the amount of extra space needed to vertical align
        // the first line is
        let expectedHeadLeadLength = maxPeerNameLength - parameter.name.text.count + 1
        let expectedHeadLead = String(Array(repeating: " ", count: expectedHeadLeadLength))
        if let lead = parameter.description.first?.lead, lead != expectedHeadLead {
            result.append(.verticalAlignment(expectedHeadLeadLength, parameter.name.text, 1))
        }
        // For the rest of the lines in the description, it should have the length of
        // `- parameter [maxPeerNameLength]: ` for separate style
        // or
        // `- [maxPeerNameLength]: ` for grouped style
        let expectedBodyLeadLength = parameter.keyword == nil ? 4 + maxPeerNameLength : 14 + maxPeerNameLength
        for (index, line) in parameter.description.dropFirst().enumerated() {
            if !line.lead.allSatisfy({ $0 == " " }) || (line.lead.count < expectedBodyLeadLength &&
                !line.lead.isEmpty && !line.text.isEmpty)
            {
                result.append(.verticalAlignment(expectedBodyLeadLength, parameter.name.text, index + 2))
            }
        }
    } else if alignAfterColon {
        if let lead = parameter.description.first?.lead, lead != " " {
            result.append(.verticalAlignment(1, parameter.name.text, 1))
        }

        let standardPaddingLength: Int
        if parameter.keyword != nil {
            standardPaddingLength = 15 + parameter.name.text.count
        } else {
            standardPaddingLength = 7 + parameter.name.text.count
        }

        let standardPadding = String(Array(repeating: " ", count: standardPaddingLength))
        for (index, line) in parameter.description.dropFirst().enumerated() {
            if line.lead != standardPadding {
                result.append(.verticalAlignment(standardPaddingLength, parameter.name.text, index + 2))
            }
        }
    }

    let expectedKeyword = firstLetterUpper ? "Parameter" : "parameter"
    if let keyword = parameter.keyword?.text, keyword != expectedKeyword {
        result.append(.keywordCasingForParameter(keyword, expectedKeyword, parameter.name.text))
    }

    return result
}

func commonSequence(_ parameters: [Parameter], _ docs: DocString) -> [Parameter] {
    var cache = [Int: [Int: [Parameter]]]()
    func lcs(_ sig: [Parameter], _ sigIndex: Int, _ doc: [DocString.Entry],
             _ docIndex: Int) -> [Parameter]
    {
        if let cached = cache[sigIndex]?[docIndex] {
            return cached
        }

        guard sigIndex < sig.count && docIndex < doc.count else {
            return []
        }

        if sig[sigIndex].name == doc[docIndex].name.text {
            return [sig[sigIndex]] + lcs(sig, sigIndex + 1, doc, docIndex)
        }

        let a = lcs(sig, sigIndex + 1, doc, docIndex)
        let b = lcs(sig, sigIndex, doc, docIndex + 1)

        let result = a.count > b.count ? a : b
        cache[sigIndex] = cache[sigIndex, default: [:]].merging([docIndex: result]) { $1 }

        return result
    }

    return lcs(parameters, 0, docs.parameters, 0)
}
