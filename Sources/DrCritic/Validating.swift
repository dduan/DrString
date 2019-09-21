import DrDecipher
import DrCrawler

public func validate(_ documentable: Documentable, ignoreThrows: Bool) throws -> [DocProblem] {
    guard !documentable.docLines.isEmpty, let docs = try? parse(lines: documentable.docLines) else {
        return []
    }

    switch documentable.details {
    case let .function(_, doesThrow, returnType, parameters):
        let details = try findParameterProblems(parameters, docs)
            + (!ignoreThrows && doesThrow && docs.throws.isEmpty ? [.missingThrow] : [])
            + (returnType != nil && docs.returns.isEmpty ? [.missingReturn(returnType ?? "")] : [])
        if details.isEmpty {
            return []
        }

        return [DocProblem(docName: documentable.name, filePath: documentable.path, line: documentable.line, column: documentable.column, details: details)]
    default:
        return []
    }
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
            nextCommon = commonIter.next()
        } else {
            result.append(.redundantParameter(docParam.name.text))
        }
    }

    return result
}

func commonSequence(_ parameters: [Parameter], _ docs: DocString) -> [Parameter] {
    var cache = [Int: [Int: [Parameter]]]()
    func lcs(_ sig: [Parameter], _ sigIndex: Int, _ doc: [DocString.Parameter],
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
