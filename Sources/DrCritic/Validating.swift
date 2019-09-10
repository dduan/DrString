import DrDecipher
import DrCrawler

public func validate(_ documentable: Documentable) throws -> [DocProblem] {
    var result = [DocProblem]()
    switch documentable {
    case .function(let signature, let rawDoc):
        let docs = try parse(lines: rawDoc.content.split(separator: "\n").map(String.init))
        let problems = try findParameterProblems(signature, docs)
        if !problems.isEmpty {
            result.append(DocProblem(existingDocs: rawDoc, details: problems))
        }
    }

    return result
}

func findParameterProblems(_ signature: FunctionSignature, _ docs: DocString) throws -> [DocProblem.Detail] {
    var result = [DocProblem.Detail]()
    let commonality = commonSequence(signature, docs)
    var commonIter = commonality.makeIterator()
    var nextCommon = commonIter.next()
    for param in signature.parameters {
        if param == nextCommon {
            nextCommon = commonIter.next()
        } else {
            result.append(.missingParameter(param.name, param.type))
        }
    }

    commonIter = commonality.makeIterator()
    nextCommon = commonIter.next()
    for docParam in docs.parameters {
        if docParam.name == nextCommon?.name {
            nextCommon = commonIter.next()
        } else {
            result.append(.redundantParameter(docParam.name))
        }
    }

    return result
}

func commonSequence(_ signature: FunctionSignature, _ docs: DocString) -> [FunctionSignature.Parameter] {
    var cache = [Int: [Int: [FunctionSignature.Parameter]]]()
    func lcs(_ sig: [FunctionSignature.Parameter], _ sigIndex: Int, _ doc: [DocString.Parameter],
             _ docIndex: Int) -> [FunctionSignature.Parameter]
    {
        if let cached = cache[sigIndex]?[docIndex] {
            return cached
        }

        guard sigIndex < sig.count && docIndex < doc.count else {
            return []
        }

        if sig[sigIndex].name == doc[docIndex].name {
            return [sig[sigIndex]] + lcs(sig, sigIndex + 1, doc, docIndex)
        }

        let a = lcs(sig, sigIndex + 1, doc, docIndex)
        let b = lcs(sig, sigIndex, doc, docIndex + 1)

        let result = a.count > b.count ? a : b
        cache[sigIndex] = cache[sigIndex, default: [:]].merging([docIndex: result]) { $1 }

        return result
    }

    return lcs(signature.parameters, 0, docs.parameters, 0)
}
