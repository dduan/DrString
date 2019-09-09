import DrDecipher
import DrCrawler

public func validate(_ documentable: Documentable) throws -> [DocProblem] {
    var result = [DocProblem]()
    switch documentable {
    case .function(let signature, let rawDoc):
        let parsed = try parse(lines: rawDoc.content.split(separator: "\n").map(String.init))
        // print(signature)
        // print(parsed)
        let parsedCount = parsed.parameters.count
        let signatureCount = signature.parameters.count
        var parsedIndex = 0
        var signatureIndex = 0

        while parsedIndex < parsedCount && signatureIndex < signatureCount {
            if parsed.parameters[parsedIndex].name == signature.parameters[signatureIndex].name {
                parsedIndex += 1
                signatureIndex += 1
                continue
            }

            let parsedRemaining = parsedCount - parsedIndex
            let signatureRemaining = signatureCount - signatureIndex
            if parsedRemaining > signatureRemaining {
                result.append(.redundantParameter(parsed.parameters[parsedIndex]))
                parsedIndex += 1
            } else if parsedRemaining < signatureRemaining {
                result.append(.missingParameter(signature.parameters[signatureIndex].name))
                parsedIndex += 1
            } else {
                result.append(.redundantParameter(parsed.parameters[parsedIndex]))
                parsedIndex += 1
                signatureIndex += 1
            }
        }

        while signatureIndex < signatureCount {
            result.append(.missingParameter(signature.parameters[signatureIndex].name))
            signatureIndex += 1
        }

        while parsedIndex < parsedCount {
            result.append(.redundantParameter(parsed.parameters[parsedIndex]))
            parsedIndex += 1
        }
    }

    return result
}

func commonSequence(_ signature: FunctionSignature, _ docs: DocString) -> [FunctionSignature.Parameter] {
    func lcs(_ sig: [FunctionSignature.Parameter], _ sigIndex: Int, _ doc: [DocString.Parameter],
             _ docIndex: Int) -> [FunctionSignature.Parameter]
    {
        guard sigIndex < sig.count && docIndex < doc.count else {
            return []
        }

        if sig[sigIndex].name == doc[docIndex].name {
            return [sig[sigIndex]] + lcs(sig, sigIndex + 1, doc, docIndex)
        }

        let a = lcs(sig, sigIndex + 1, doc, docIndex)
        let b = lcs(sig, sigIndex, doc, docIndex + 1)

        return a.count > b.count ? a : b
    }

    return lcs(signature.parameters, 0, docs.parameters, 0)
}
