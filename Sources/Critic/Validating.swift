import Models
import Decipher

struct RelativeLocation {
    var line: Int
    var column: Int

    init(_ line: Int = 0, _ column: Int = 0) {
        self.line = line
        self.column = column
    }
}

extension Documentable {
    public func validate(ignoreThrows: Bool, ignoreReturns: Bool, firstLetterUpper: Bool,
                         needsSeparation: [Section], verticalAlign: Bool, parameterStyle: ParameterStyle,
                         alignAfterColon: [Section])
        throws -> [DocProblem]
    {
        guard !self.docLines.isEmpty,
            let docs = try? parse(
                location: .init(
                    path: self.path, line: self.startLine - self.docLines.count, column: self.startColumn),
                lines: self.docLines) else
        {
            return []
        }

        let doesThrow = self.details.throws
        let returnType = self.details.returnType
        let parameters = self.details.parameters

        let details = try findDescriptionProblems(docs, needsSeparator: needsSeparation.contains(.description))
            + findParameterProblems(fallback: .init(self.docLines.count, self.startColumn),
                                    docs.description.count, parameters, docs,
                                    firstLetterUpper, needsSeparation: needsSeparation.contains(.parameters),
                                    verticalAlign: verticalAlign, style: parameterStyle,
                                    alignAfterColon: alignAfterColon.contains(.parameters))
            + findThrowsProblems(fallback: .init(self.startLine, self.startColumn),
                                 ignoreThrows: ignoreThrows, doesThrow: doesThrow, docs,
                                 firstLetterUpper: firstLetterUpper,
                                 needsSeparation: needsSeparation.contains(.throws),
                                 alignAfterColon: alignAfterColon.contains(.throws))
            + findReturnsProblems(fallback: .init(self.startLine, self.startColumn),
                                  ignoreReturns: ignoreReturns, docs,
                                  returnType: returnType, firstLetterUpper: firstLetterUpper,
                                  alignAfterColon: alignAfterColon.contains(.throws))

        if details.isEmpty {
            return []
        }

        let startLine = self.startLine - self.docLines.count
        return details.map { location, detail in
            return DocProblem(
                docName: self.name,
                filePath: self.path,
                line: startLine + location.line,
                column: self.startColumn + location.column,
                detail: detail
            )
        }
    }
}

func findDescriptionProblems(_ docs: DocString, needsSeparator: Bool
) -> [(RelativeLocation, DocProblem.Detail)]
{
    if needsSeparator, !docs.parameters.isEmpty ||
        docs.throws != nil ||
        docs.returns != nil, let last = docs.description.last, !last.lead.isEmpty ||
        !last.text.isEmpty
    {
        return [(.init(docs.description.count, 0), .descriptionShouldEndWithEmptyLine)]
    }

    return []
}

func findReturnsProblems(
    fallback: RelativeLocation, ignoreReturns: Bool, _ docs: DocString, returnType: String?,
    firstLetterUpper: Bool, alignAfterColon: Bool
) -> [(RelativeLocation, DocProblem.Detail)]
{
    guard let returnType = returnType else {
        if let returnDoc = docs.returns, let returnsKeyword = returnDoc.keyword?.text {
            return [(.init(returnDoc.relativeLineNumber, 0), .redundantKeyword(returnsKeyword))]
        } else {
            return []
        }
    }

    guard let returnsDoc = docs.returns else {
        return ignoreReturns ? [] : [(fallback, .missingReturn(returnType))]
    }

    var lineNumber = returnsDoc.relativeLineNumber

    var column = 4 // accumulate columns that has been considered so far.
    let keywordText = returnsDoc.keyword?.text ?? ((firstLetterUpper ? "R" : "r") + "eturns")
    var result = [(RelativeLocation, DocProblem.Detail)]()

    if returnsDoc.preDashWhitespace != " " {
        result.append((.init(lineNumber, column), .preDashSpace(keywordText, returnsDoc.preDashWhitespace)))
    }

    column += returnsDoc.preDashWhitespace.count + 1 // 1 for the dash itself

    if let preKeyword = returnsDoc.keyword?.lead  {
        if preKeyword != " " {
            result.append((.init(lineNumber, column), .spaceBetweenDashAndKeyword(keywordText, preKeyword)))
        }
        column += preKeyword.count
    }

    let expectedKeyword = firstLetterUpper ? "Returns" : "returns"

    if let keyword = returnsDoc.keyword?.text {
        if keyword != expectedKeyword {
            result.append((.init(lineNumber, column), .keywordCasing(keyword, expectedKeyword)))
        }

        column += keyword.count
    }


    if returnsDoc.preColonWhitespace != "" {
        result.append((
            .init(lineNumber, column), .spaceBeforeColon(returnsDoc.preColonWhitespace, keywordText)))
        column += returnsDoc.preColonWhitespace.count
    }


    if !returnsDoc.hasColon {
        result.append((.init(lineNumber, column), .missingColon(expectedKeyword)))
    } else {
        column += 1
    }

    if let postColonLead = returnsDoc.description.first?.lead {
        if postColonLead != " " {
            result.append((.init(lineNumber, column), .spaceAfterColon(keywordText, postColonLead)))
        }

        column += postColonLead.count
    }

    if alignAfterColon {
        let standardPaddingLength = 12
        let standardPadding = String(Array(repeating: " ", count: standardPaddingLength))
        for (index, line) in returnsDoc.description.dropFirst().enumerated() {
            lineNumber += 1
            if line.lead < standardPadding && !(line.lead.isEmpty && line.text.isEmpty) {
                result.append((
                    .init(lineNumber, 4 + line.lead.count),
                    .verticalAlignment(standardPaddingLength, keywordText, index + 2)))
            }
        }
    }

    return result
}

func findThrowsProblems(
    fallback: RelativeLocation, ignoreThrows: Bool, doesThrow: Bool, _ docs: DocString,
    firstLetterUpper: Bool, needsSeparation: Bool, alignAfterColon: Bool
) -> [(RelativeLocation, DocProblem.Detail)]
{
    if !doesThrow {
        if let throwsKeyword = docs.throws?.keyword?.text {
            return [(fallback, .redundantKeyword(throwsKeyword))]
        } else {
            return []
        }
    }

    guard let throwsDoc = docs.throws else {
        return ignoreThrows ? [] : [(fallback, .missingThrow)]
    }

    var lineNumber = throwsDoc.relativeLineNumber
    var column = 4

    let keywordText = throwsDoc.keyword?.text ?? ((firstLetterUpper ? "T" : "t") + "hrows")
    var result = [(RelativeLocation, DocProblem.Detail)]()

    if throwsDoc.preDashWhitespace != " " {
        result.append((.init(lineNumber, column), .preDashSpace("throws", throwsDoc.preDashWhitespace)))
    }

    column += throwsDoc.preDashWhitespace.count + 1

    if let preKeyword = throwsDoc.keyword?.lead {
        if preKeyword != " " {
            result.append((.init(lineNumber, column), .spaceBetweenDashAndKeyword(keywordText, preKeyword)))
        }

        column += preKeyword.count
    }

    let expectedKeyword = firstLetterUpper ? "Throws" : "throws"
    if let keyword = throwsDoc.keyword?.text {
        if keyword != expectedKeyword {
            result.append((.init(lineNumber, column), .keywordCasing(keyword, expectedKeyword)))
        }

        column += keyword.count
    }

    if throwsDoc.preColonWhitespace != "" {
        result.append((
            .init(lineNumber, column), .spaceBeforeColon(throwsDoc.preColonWhitespace, keywordText)))
        column += throwsDoc.preColonWhitespace.count
    }


    if !throwsDoc.hasColon {
        result.append((.init(lineNumber, column), .missingColon(expectedKeyword)))
    } else {
        column += 1
    }

    if let postColonLead = throwsDoc.description.first?.lead {
        if postColonLead != " " {
            result.append((.init(lineNumber, column), .spaceAfterColon(keywordText, postColonLead)))
        }

        column += postColonLead.count
    }

    if alignAfterColon {
        let standardPaddingLength = 11
        let standardPadding = String(Array(repeating: " ", count: standardPaddingLength))
        for (index, line) in throwsDoc.description.dropFirst().enumerated() {
            lineNumber += 1
            if line.lead < standardPadding && !(line.lead.isEmpty && line.text.isEmpty) {
                result.append((
                    .init(lineNumber, 4 + line.lead.count),
                    .verticalAlignment(standardPaddingLength, keywordText, index + 2)))
            }
        }
    }

    if needsSeparation, docs.returns != nil, let last = throwsDoc.description.last, !last.lead.isEmpty ||
        !last.text.isEmpty
    {
        let backupKeyword = firstLetterUpper ? "Throws" : "throws"
        result.append((
            .init(lineNumber, 0), .sectionShouldEndWithEmptyLine(throwsDoc.keyword?.text ?? backupKeyword)))
    }

    return result
}

func findParameterProblems(fallback: RelativeLocation, _ line: Int, _ parameters: [Parameter],
                           _ docs: DocString, _ firstLetterUpper: Bool, needsSeparation: Bool,
                           verticalAlign: Bool, style: ParameterStyle, alignAfterColon: Bool) throws
    -> [(RelativeLocation, DocProblem.Detail)]
{
    var result = [(RelativeLocation, DocProblem.Detail)]()

    var lineNumber = line
    var column = 4

    if let header = docs.parameterHeader, let keyword = header.keyword {
        if header.preDashWhitespace != " " {
            result.append((
                .init(lineNumber, column), .preDashSpace(keyword.text, header.preDashWhitespace)))
        }

        column += header.preDashWhitespace.count + 1

        if keyword.lead != " " {
            result.append((
                .init(lineNumber, column), .spaceBetweenDashAndKeyword(keyword.text, keyword.lead)))
        }

        column += keyword.lead.count

        if !header.preColonWhitespace.isEmpty {
            result.append((
                .init(lineNumber, column), .spaceBeforeColon(header.preColonWhitespace, keyword.text)))
            column += header.preColonWhitespace.count
        }

        let expectedKeyword = firstLetterUpper ? "Parameters" : "parameters"
        if keyword.text != expectedKeyword {
            result.append((.init(lineNumber, column), .keywordCasing(keyword.text, expectedKeyword)))
        }

        column += keyword.text.count

        if !header.hasColon {
            result.append((.init(lineNumber, column - 1), .missingColon(expectedKeyword)))
        } else {
            column += 1
        }

        if !header.description.isEmpty {
            result.append((.init(lineNumber, column), .redundantTextFollowingParameterHeader(keyword.text)))
        }

        if style == .separate {
            result.append((.init(lineNumber, 0), .parametersAreNotSeparated))
        }

        lineNumber += 1
    } else if docs.parameterHeader == nil, style == .grouped, docs.parameters.count > 1 {
        result.append((.init(lineNumber, 0), .parametersAreNotGrouped))
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
            result.append((fallback, .missingParameter(param.name, param.type)))
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
            result.append((.init(docParam.relativeLineNumber, 0), .redundantParameter(docParam.name.text)))
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
        let lastLineNumber = docs.parameters.last.map { $0.relativeLineNumber + $0.description.count } ?? 0
        result.append((.init(lastLineNumber, 0), .sectionShouldEndWithEmptyLine(lastParam.name.text)))
    }

    return result
}

func findDocParameterFormatProblems(_ parameter: DocString.Entry, _ maxPeerNameLength: Int,
                                    _ firstLetterUpper: Bool, _ verticalAlign: Bool, alignAfterColon: Bool)
    -> [(RelativeLocation, DocProblem.Detail)]
{
    var result = [(RelativeLocation, DocProblem.Detail)]()
    var lineNumber = parameter.relativeLineNumber
    var column = 4

    if let keyword = parameter.keyword {
        if parameter.preDashWhitespace != " " {
            result.append((
                .init(lineNumber, column),
                .preDashSpaceInParameter(1, parameter.preDashWhitespace, parameter.name.text)))
        }

        column += parameter.preDashWhitespace.count + 1

        if keyword.lead != " " {
            result.append(
                (.init(lineNumber, column),
                .spaceBetweenDashAndParameterKeyword(keyword.lead, keyword.text, parameter.name.text)))
        }

        column += keyword.lead.count

        let expectedKeyword = firstLetterUpper ? "Parameter" : "parameter"
        if keyword.text != expectedKeyword {
            result.append((
                .init(lineNumber, column),
                .keywordCasingForParameter(keyword.text, expectedKeyword, parameter.name.text)))
        }

        column += keyword.text.count

        if parameter.name.lead != " " {
            result.append((
                .init(lineNumber, column),
                .spaceBeforeParameterName(parameter.name.lead, keyword.text, parameter.name.text)))
        }

        column += parameter.name.lead.count
    } else if parameter.preDashWhitespace != "   " {
        result.append((
            .init(lineNumber, column),
            .preDashSpaceInParameter(3, parameter.preDashWhitespace, parameter.name.text)))
        column += 4
    }

    column += parameter.name.text.count
    if parameter.preColonWhitespace != "" {
        result.append((
            .init(lineNumber, column), .spaceBeforeColon(parameter.preColonWhitespace, parameter.name.text)))
        column += parameter.preColonWhitespace.count
    }

    if !parameter.hasColon {
        result.append((.init(lineNumber, column), .missingColon(parameter.name.text)))
    } else {
        column += 1
    }

    if verticalAlign || alignAfterColon {
        // Vertical alignment
        // Knowing the longest name's length among peers, the amount of extra space needed to vertical align
        // the first line is
        let expectedHeadLeadLength = maxPeerNameLength - parameter.name.text.count + 1
        let expectedHeadLead = String(Array(repeating: " ", count: expectedHeadLeadLength))
        if let lead = parameter.description.first?.lead, lead != expectedHeadLead {
            result.append((
                .init(lineNumber, column),
                .verticalAlignment(expectedHeadLeadLength, parameter.name.text, 1)))
            column += lead.count
        }
        // For the rest of the lines in the description, it should have the length of
        // `- parameter [maxPeerNameLength]: ` for separate style
        // or
        // `   - [maxPeerNameLength]: ` for grouped style
        let expectedBodyLeadLength = (parameter.keyword == nil ? 7 : 15) + maxPeerNameLength
        for (index, line) in parameter.description.dropFirst().enumerated() {
            lineNumber += 1
            if !line.lead.allSatisfy({ $0 == " " }) || (line.lead.count < expectedBodyLeadLength &&
                !line.lead.isEmpty && !line.text.isEmpty)
            {
                result.append((
                    .init(lineNumber, 4 + line.lead.count),
                    .verticalAlignment(expectedBodyLeadLength, parameter.name.text, index + 2)))
            }
        }
    }

    return result
}
