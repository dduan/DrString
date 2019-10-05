import Decipher
import Crawler

public func validate(_ documentable: Documentable, ignoreThrows: Bool, firstLetterUpper: Bool?,
                     needsSeparation: [Section]) throws -> DocProblem?
{
    guard !documentable.docLines.isEmpty, let docs = try? parse(lines: documentable.docLines) else {
        return nil
    }

    switch documentable.details {
    case let .function(doesThrow, returnType, parameters):
        let details = try findDescriptionProblems(docs, needsSeparator: needsSeparation.contains(.description))
            + findParameterProblems(parameters, docs, firstLetterUpper, needsSeparation: needsSeparation.contains(.parameters))
            + findThrowsProblems(ignoreThrows: ignoreThrows, doesThrow: doesThrow, docs, firstLetterUpper, needsSeparation: needsSeparation.contains(.throws))
            + findReturnsProblems(docs, returnType, firstLetterUpper)

        if details.isEmpty {
            return nil
        }

        return
            DocProblem(
                docName: documentable.name,
                filePath: documentable.path,
                line: documentable.line,
                column: documentable.column,
                details: details
            )
    default:
        return nil
    }
}

func findDescriptionProblems(_ docs: DocString, needsSeparator: Bool) -> [DocProblem.Detail] {
    var result = [DocProblem.Detail]()
    if needsSeparator, !docs.parameters.isEmpty || docs.throws != nil || docs.returns != nil, let last = docs.description.last, !last.lead.isEmpty || !last.text.isEmpty {
        result.append(.descriptionShouldEndWithEmptyLine)
    }

    return result
}

func findReturnsProblems(_ docs: DocString, _ returnType: String?, _ firstLetterUpper: Bool?)
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
        return [.missingReturn(returnType)]
    }

    var result = [DocProblem.Detail]()

    if returnsDoc.preDashWhitespace != " " {
        result.append(.preDashSpace("returns", returnsDoc.preDashWhitespace))
    }

    if let preKeyword = returnsDoc.keyword?.lead, preKeyword != " " {
        result.append(.spaceBetweenDashAndKeyword("returns", preKeyword))
    }

    if returnsDoc.preColonWhitespace != "" {
        result.append(.spaceBeforeColon(returnsDoc.preColonWhitespace, "returns"))
    }

    if let postColonLead = returnsDoc.description.first?.lead, postColonLead != " " {
        result.append(.spaceAfterColon("returns", postColonLead))
    }

    switch firstLetterUpper {
    case .none:
        break
    case .some(true):
        let expected = "Returns"
        if let keyword = returnsDoc.keyword?.text, keyword != expected {
            result.append(.keywordCasing(keyword, expected))
        }
    case .some(false):
        let expected = "returns"
        if let keyword = returnsDoc.keyword?.text, keyword != expected {
            result.append(.keywordCasing(keyword, expected))
        }
    }

    return result
}

func findThrowsProblems(ignoreThrows: Bool, doesThrow: Bool, _ docs: DocString, _ firstLetterUpper: Bool?, needsSeparation: Bool)
    -> [DocProblem.Detail]
{
    if !doesThrow, let throwsKeyword = docs.throws?.keyword?.text {
        return [.redundantKeyword(throwsKeyword)]
    } else if !doesThrow || ignoreThrows {
        return []
    }

    guard let throwsDoc = docs.throws else {
        return [.missingThrow]
    }

    var result = [DocProblem.Detail]()

    if throwsDoc.preDashWhitespace != " " {
        result.append(.preDashSpace("throws", throwsDoc.preDashWhitespace))
    }

    if let preKeyword = throwsDoc.keyword?.lead, preKeyword != " " {
        result.append(.spaceBetweenDashAndKeyword("throws", preKeyword))
    }

    if throwsDoc.preColonWhitespace != "" {
        result.append(.spaceBeforeColon(throwsDoc.preColonWhitespace, "throws"))
    }

    if let postColonLead = throwsDoc.description.first?.lead, postColonLead != " " {
        result.append(.spaceAfterColon("throws", postColonLead))
    }

    switch firstLetterUpper {
    case .none:
        break
    case .some(true):
        let expected = "Throws"
        if let keyword = throwsDoc.keyword?.text, keyword != expected {
            result.append(.keywordCasing(keyword, expected))
        }
    case .some(false):
        let expected = "throws"
        if let keyword = throwsDoc.keyword?.text, keyword != expected {
            result.append(.keywordCasing(keyword, expected))
        }
    }

    if needsSeparation, docs.returns != nil, let last = throwsDoc.description.last, !last.lead.isEmpty ||
        !last.text.isEmpty
    {
        let backupKeyword = firstLetterUpper == true ? "Throws" : "throws"
        result.append(.sectionShouldEndWithEmptyLine(throwsDoc.keyword?.text ?? backupKeyword))
    }

    return result
}

func findParameterProblems(_ parameters: [Parameter], _ docs: DocString, _ firstLetterUpper: Bool?,
                           needsSeparation: Bool) throws -> [DocProblem.Detail]
{
    var result = [DocProblem.Detail]()

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
        result += findDocParameterFormatProblems(docParam, maxNameLength, firstLetterUpper)
    }

    if needsSeparation, docs.returns != nil || docs.throws != nil, let lastParam = docs.parameters.last,
        let last = lastParam.description.last, !last.lead.isEmpty || !last.text.isEmpty
    {
        result.append(.sectionShouldEndWithEmptyLine(lastParam.name.text))
    }

    return result
}

func findDocParameterFormatProblems(_ parameter: DocString.Entry, _ maxPeerNameLength: Int,
                                    _ firstLetterUpper: Bool?) -> [DocProblem.Detail]
{
    var result = [DocProblem.Detail]()

    if let keyword = parameter.keyword {
        if parameter.preDashWhitespace != " " {
            result.append(.preDashSpaceInParameter(1, parameter.preDashWhitespace, parameter.name.text))
        }

        if keyword.lead != " " {
            result.append(
                .spaceBetweenDashAndParamaterKeyword(keyword.lead, keyword.text, parameter.name.text))
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

    // Vertical alignment
    // Knowing the longest name's length among peers, the amount of extra space needed to vertical align the
    // first line is
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

    switch firstLetterUpper {
    case .none:
        break
    case .some(true):
        let expected = "Parameter"
        if let keyword = parameter.keyword?.text, keyword != expected {
            result.append(.keywordCasingForParameter(keyword, expected, parameter.name.text))
        }
    case .some(false):
        let expected = "parameter"
        if let keyword = parameter.keyword?.text, keyword != expected {
            result.append(.keywordCasingForParameter(keyword, expected, parameter.name.text))
        }
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
