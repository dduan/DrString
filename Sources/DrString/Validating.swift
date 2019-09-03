import DocString

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
                result.append(.unrecognizedParameter(parsed.parameters[parsedIndex]))
                parsedIndex += 1
            } else if parsedRemaining < signatureRemaining {
                result.append(.missingParameter(signature.parameters[signatureIndex].name))
                parsedIndex += 1
            } else {
                result.append(.unrecognizedParameter(parsed.parameters[parsedIndex]))
                parsedIndex += 1
                signatureIndex += 1
            }
        }

        while signatureIndex < signatureCount {
            result.append(.missingParameter(signature.parameters[signatureIndex].name))
            signatureIndex += 1
        }

        while parsedIndex < parsedCount {
            result.append(.unrecognizedParameter(parsed.parameters[parsedIndex]))
            parsedIndex += 1
        }
    }

    return result
}
