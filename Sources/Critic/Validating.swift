import Decipher
import Crawler

public func validate(_ documentable: Documentable, ignoreThrows: Bool) throws -> [DocProblem] {
    guard !documentable.docLines.isEmpty, let docs = try? parse(lines: documentable.docLines) else {
        return []
    }

    switch documentable.details {
    case let .function(_, doesThrow, returnType, parameters):
        let details = try findParameterProblems(parameters, docs)
            + (!ignoreThrows && doesThrow ? findThrowsProblems(docs) : [])
            + (returnType != nil && docs.returns == nil ? [.missingReturn(returnType ?? "")] : [])

        if details.isEmpty {
            return []
        }

        return [DocProblem(docName: documentable.name, filePath: documentable.path, line: documentable.line, column: documentable.column, details: details)]
    default:
        return []
    }
}

func findThrowsProblems(_ docs: DocString) -> [DocProblem.Detail] {
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
    return result
}

func findParameterProblems(_ parameters: [Parameter], _ docs: DocString) throws -> [DocProblem.Detail] {
    var result = [DocProblem.Detail]()
    let commonality = commonSequence(parameters, docs)
    var commonIter = commonality.makeIterator()
    var nextCommon = commonIter.next()
    for param in parameters {
        if param == nextCommon {
            nextCommon = commonIter.next()
        } else {
            result.append(.missingParameter(param.name, param.type))
        }
    }

    commonIter = commonality.makeIterator()
    nextCommon = commonIter.next()
    for docParam in docs.parameters {
        if docParam.name.text == nextCommon?.name {
            result += findDocParameterFormatProblems(docParam)
            nextCommon = commonIter.next()
        } else {
            result.append(.redundantParameter(docParam.name.text))
        }
    }

    return result
}

func findDocParameterFormatProblems(_ parameter: DocString.Entry) -> [DocProblem.Detail] {
    var result = [DocProblem.Detail]()

    if let keyword = parameter.keyword {
        if parameter.preDashWhitespace != " " {
            result.append(.preDashSpaceInParameter(1, parameter.preDashWhitespace, parameter.name.text))
        }

        if keyword.lead != " " {
            result.append(.spaceBetweenDashAndParamaterKeyword(keyword.lead, keyword.text, parameter.name.text))
        }

        if keyword.text.lowercased() != "parameter" {
            // TODO: sometimes it should be "Paramater" and not "parameter"
            result.append(.keywordSpellingForParameter(keyword.text, "parameter", parameter.name.text))
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
