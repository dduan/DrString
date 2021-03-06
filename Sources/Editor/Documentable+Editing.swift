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
        addPlaceholder: Bool,
        startLine: Int?,
        endLine: Int?
    ) -> [Edit]
    {
        if let startLine = startLine, let endLine = endLine,
            self.endLine < startLine || (self.startLine - self.docLines.count) > endLine
        {
            return []
        }

        let perhapsDocs = self.docLines.isEmpty && addPlaceholder ? nil : try? parse(location: .init(),
                                                                                     lines: self.docLines)
        if !addPlaceholder && perhapsDocs == nil {
            return []
        }

        var docs = perhapsDocs ?? DocString(
            location: .init(),
            description: [], parameterHeader: nil, parameters: [], returns: nil, throws: nil)

        if addPlaceholder {
            self.addDescription(to: &docs)
            self.addParameters(to: &docs)
            self.addThrows(to: &docs, ignoreThrows: ignoreThrows)
            self.addReturns(to: &docs, ignoreReturns: ignoreReturns)
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

    private func addDescription(to docs: inout DocString) {
        if docs.description.isEmpty {
            docs.description.append(.init(" ", "<#\(self.name)#>"))
        }
    }

    private func addParameters(to docs: inout DocString) {
        let parameters = self.details.parameters

        var parameterDocs = [DocString.Entry]()

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
                        relativeLineNumber: 0,
                        preDashWhitespaces: "",
                        keyword: nil,
                        name: .init("", param.name),
                        preColonWhitespace: "",
                        hasColon: true,
                        description: [.init("", "<#\(param.type)#>")]))
            }
        }

        docs.parameters = parameterDocs
    }

    private func addThrows(to docs: inout DocString, ignoreThrows: Bool) {
        let doesThrow = self.details.throws
        if doesThrow && docs.throws == nil && !ignoreThrows {
            docs.throws = .init(
                relativeLineNumber: 0,
                preDashWhitespaces: "",
                keyword: nil,
                name: .empty,
                preColonWhitespace: "",
                hasColon: true,
                description: [.init(" ", "<#Error#>")]
            )
        }
    }

    private func addReturns(to docs: inout DocString, ignoreReturns: Bool) {
        let returnType = self.details.returnType
        if let returnType = returnType, docs.returns == nil && !ignoreReturns {
            docs.returns = .init(
                relativeLineNumber: 0,
                preDashWhitespaces: "",
                keyword: nil,
                name: .empty,
                preColonWhitespace: "",
                hasColon: true,
                description: [.init(" ", "<#\(returnType)#>")]
            )
        }
    }
}
