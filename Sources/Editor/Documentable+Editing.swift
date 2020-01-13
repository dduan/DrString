import Models
import Decipher

extension Documentable {
    public func format(
        columnLimit: Int?,
        verticalAlign: Bool,
        alignAfterColon: [Section],
        firstLetterUpperCase: Bool,
        parameterStyle: ParameterStyle,
        separations: [Section],
        ignoreThrows: Bool,
        ignoreReturns: Bool,
        addPlaceholder: Bool
    ) -> [Edit]
    {
        guard case let .function(doesThrow, returnType, parameters) = self.details,
            (!self.docLines.isEmpty || addPlaceholder) else
        {
            return []
        }

        let perhapsDocs = try? parse(lines: self.docLines)
        if !addPlaceholder && perhapsDocs == nil {
            return []
        }

        var docs = perhapsDocs ?? DocString(
            description: [], parameterHeader: nil, parameters: [], returns: nil, throws: nil)

        var parameterDocs = [DocString.Entry]()
        if addPlaceholder {
            let commonality = commonSequence(parameters, docs)
            var commonIter = commonality.makeIterator()
            var nextCommon = commonIter.next()
            var docsIter = docs.parameters.makeIterator()
            var nextDoc = docsIter.next()

            for param in parameters {
                if param == nextCommon {
                    while let doc = nextDoc, doc.name.text != param.name {
                        parameterDocs.append(doc)
                        nextDoc = docsIter.next()
                    }

                    if let doc = nextDoc {
                        parameterDocs.append(doc)
                        nextDoc = docsIter.next()
                    }

                    nextCommon = commonIter.next()
                } else {
                    parameterDocs.append(
                        .init(
                            preDashWhitespaces: "",
                            keyword: nil,
                            name: .init("", param.name),
                            preColonWhitespace: "",
                            hasColon: true,
                            description: [.init("", "<#\(param.type)#>")]))
                }
            }

            docs.parameters = parameterDocs

            if doesThrow && docs.throws == nil && !ignoreThrows {
                docs.throws = .init(
                    preDashWhitespaces: "",
                    keyword: nil,
                    name: .empty,
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [.init(" ", "<#Error#>")]
                )
            }

            if let returnType = returnType, docs.returns == nil && !ignoreReturns {
                docs.returns = .init(
                    preDashWhitespaces: "",
                    keyword: nil,
                    name: .empty,
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [.init(" ", "<#\(returnType)#>")]
                )
            }
        }

        let formatted = docs.reformat(
            initialColumn: self.startColumn,
            columnLimit: columnLimit,
            verticalAlign: verticalAlign,
            alignAfterColon: alignAfterColon,
            firstLetterUpperCase: firstLetterUpperCase,
            parameterStyle: parameterStyle,
            separations: separations)

        if formatted != self.docLines {
            let padding = String(Array(repeating: " ", count: self.startColumn))
            return [
                Edit(
                    startingLine: self.startLine - self.docLines.count,
                    endingLine: self.startLine,
                    text: formatted.map { padding + $0 })
            ]
        } else {
            return []
        }
    }
}
