import Decipher

enum KeywordToFormat {
    case `throws`
    case returns
}

extension DocString.Entry {
    var excessPostColonWhitespaces: Int {
        let keywordCount = (self.keyword?.lead.count ?? 0) + (self.keyword?.text.count ?? 0)
        let preColonCount = self.preDashWhitespace.count + 1 + keywordCount + self.name.lead.count +
            self.name.text.count + self.preColonWhitespace.count + 1
        guard let firstLineLead = self.description.first?.lead, case let excess = firstLineLead.count - 1,
            excess > 0 else
        {
            return 0
        }

        if self.description.dropFirst().contains(where: { ($0.lead.count - preColonCount) < excess }) {
            return 0
        } else {
            return excess
        }
    }

    func formatAsParameter(initialColumn: Int, columnLimit: Int?, maxPeerNameLength: Int?,
                           firstLetterUpperCase: Bool, grouped: Bool, alignAfterColon: Bool) -> [String]
    {
        let keyword = firstLetterUpperCase ? "Parameter" : "parameter"
        let fullKeyword = grouped ? "" : " \(keyword)"
        let preDash = grouped ? "   " : " "

        let verticalAlign = maxPeerNameLength != nil
        let verticalAlignPaddingCount = maxPeerNameLength.map {  $0 - self.name.text.count } ?? 0
        let verticalAlignPadding = String(Array(repeating: " ", count: verticalAlignPaddingCount))
        let firstLineHeader = "\(preDash)-\(fullKeyword) \(self.name.text): \(verticalAlignPadding)"

        let headerReplacement = String(Array(repeating: " ", count: firstLineHeader.count))
        let excess = max(0, self.excessPostColonWhitespaces - verticalAlignPaddingCount)

        var result = self.description.enumerated().flatMap { (index, line) -> [String] in
            if line.text.isEmpty {
                return index > 0 ? ["///"] : [""]
            }

            let lead = line.lead.starts(with: " ") ? line.lead : " "
            let mustStartAfterColon = verticalAlign || alignAfterColon
            let includeHeader = mustStartAfterColon && headerReplacement.count >= line.lead.count
            let padding = mustStartAfterColon && (headerReplacement.count > lead.count - excess) ? headerReplacement[...] : lead.dropLast(excess)
            let standardStart = initialColumn
                + 3 // `///`
                + padding.count
                - excess

            let lines: [String]
            if let columnLimit = columnLimit {
                let contentStart = includeHeader ? standardStart : lead.count + 3 + initialColumn
                let maxContentWidth = columnLimit
                    - (contentStart > columnLimit ? standardStart : contentStart)
                if maxContentWidth > 0 {
                    if index == 0 {
                        let firsts = fold(line: line.text, byLimit: columnLimit - (initialColumn + 3 + firstLineHeader.count))
                        let rest = fold(line: firsts.dropFirst().joined(separator: " "),
                                        byLimit: maxContentWidth)
                        lines = [firsts[0]] + rest
                    } else {
                        lines = fold(line: line.text, byLimit: maxContentWidth)
                    }
                } else {
                    lines = [line.text]
                }
            } else {
                lines = [line.text]
            }

            if index == 0 {
                return [lines[0]] + lines.dropFirst().map { "///\(padding)\($0)" }
            } else {
                return lines.map { "///\(padding)\($0)" }
            }
        }

        if let firstLineContent = result.first {
            if firstLineContent.allSatisfy({ $0.isWhitespace }) {
                result[0] = "///\(firstLineHeader.dropLast())" // remove excessive trailing space
            } else {
                result[0] = "///\(firstLineHeader)\(firstLineContent)"
            }
        }

        return result
    }

    func format(_ keywordToFormat: KeywordToFormat, initialColumn: Int, columnLimit: Int?,
                firstLetterUpperCase: Bool, alignAfterColon: Bool) -> [String]
    {
        let keyword: String
        switch(keywordToFormat, firstLetterUpperCase) {
        case (.throws, true):
            keyword = "Throws"
        case (.throws, false):
            keyword = "throws"
        case (.returns, true):
            keyword = "Returns"
        case (.returns, false):
            keyword = "returns"
        }

        let excess = self.excessPostColonWhitespaces

        let firstLineHeader = " - \(keyword): "
        // Spaces where the headers would've been. Used in case the first line is folded and requires padding
        // upfront.
        let headerReplacement = String(Array(repeating: " ", count: firstLineHeader.count))
        var result = self.description.enumerated().flatMap { (index, line) -> [String] in
            if line.text.isEmpty {
                return index > 0 ? ["///"] : [""]
            }

            let lead = line.lead.starts(with: " ") ? line.lead : " "
            let includeHeader = alignAfterColon && firstLineHeader.count > lead.count
            let padding = alignAfterColon && (headerReplacement.count > lead.count - excess) ? headerReplacement[...] : lead.dropLast(excess)
            let lines: [String]

            let standardStart = initialColumn
                + 3
                + padding.count
                - excess

            if let columnLimit = columnLimit {
                let contentStart = includeHeader ? standardStart : lead.count + initialColumn + 3
                let maxContentWidth = columnLimit
                    - (contentStart > columnLimit ? standardStart : contentStart)
                if maxContentWidth > 0 {
                    if index == 0 {
                        let firsts = fold(line: line.text, byLimit: columnLimit - (initialColumn + 3 + firstLineHeader.count))
                        let rest = fold(line: firsts.dropFirst().joined(separator: " "),
                                        byLimit: maxContentWidth)
                        lines = [firsts[0]] + rest
                    } else {
                        lines = fold(line: line.text, byLimit: maxContentWidth)
                    }
                } else {
                    lines = [line.text]
                }
            } else {
                lines = [line.text]
            }

            if index == 0 {
                return [lines[0]] + lines.dropFirst().map { "///\(padding)\($0)" }
            } else {
                return lines.map { "///\(padding)\($0)" }
            }
        }

        if let firstLineContent = result.first {
            if firstLineContent.allSatisfy({ $0.isWhitespace }) {
                result[0] = "///\(firstLineHeader.dropLast())" // remove excessive trailing space
            } else {
                result[0] = "///\(firstLineHeader)\(firstLineContent)"
            }
        }

        return result
    }
}

extension DocString {
    func reformat(
        initialColumn: Int,
        columnLimit: Int?,
        verticalAlign: Bool,
        alignAfterColon: [Section],
        firstLetterUpperCase: Bool,
        parameterStyle: ParameterStyle,
        separations: [Section]
    ) -> [String]
    {

        let description = self.description.flatMap { line -> [String] in
            if line.text.isEmpty {
                return ["///"]
            }

            let lead = line.lead.starts(with: " ") ? line.lead : " "
            let lines: [String]
            if let columnLimit = columnLimit {
                let contentStart = initialColumn + 3 + lead.count
                let maxContentWidth = columnLimit - contentStart
                lines = maxContentWidth > 0 ? fold(line: line.text, byLimit: maxContentWidth) : [line.text]
            } else {
                lines = [line.text]
            }

            return lines.map { "///\(lead)\($0)"}
        }

        let maxParameterNameLength: Int?
        if verticalAlign {
            maxParameterNameLength = self.parameters.reduce(0) {
                max($0, $1.name.text.count)
            }
        } else {
            maxParameterNameLength = nil
        }

        let isGrouped = self.parameters.count > 1 &&
            (parameterStyle == .grouped ||
                parameterStyle == .whatever && self.parameterHeader != nil)

        let paramHeader = isGrouped ? ["/// - \(firstLetterUpperCase ? "P" : "p")arameters:"] : []

        let parameters = self.parameters.flatMap { param in
            param.formatAsParameter(
                initialColumn: initialColumn,
                columnLimit: columnLimit,
                maxPeerNameLength: maxParameterNameLength,
                firstLetterUpperCase: firstLetterUpperCase,
                grouped: isGrouped,
                alignAfterColon: alignAfterColon.contains(.parameters))
        }

        let formattedThrows = [
            self.throws.map {
                $0.format(
                    .throws,
                    initialColumn: initialColumn,
                    columnLimit: columnLimit,
                    firstLetterUpperCase: firstLetterUpperCase,
                    alignAfterColon: alignAfterColon.contains(.throws))
            }
        ]
            .compactMap { $0 }
            .flatMap { $0 }

        let formattedReturns = [
            self.returns.map {
                $0.format(
                    .returns,
                    initialColumn: initialColumn,
                    columnLimit: columnLimit,
                    firstLetterUpperCase: firstLetterUpperCase,
                    alignAfterColon: alignAfterColon.contains(.returns))
            },
        ]
            .compactMap { $0 }
            .flatMap { $0 }

        let separator = "///"

        var descriptionSeparator = [String]()
        if separations.contains(.description),
            let lastLine = description.last,
            lastLine != separator,
            (
                !parameters.isEmpty || !formattedThrows.isEmpty || !formattedReturns.isEmpty
            )
        {
            descriptionSeparator = [separator]
        }

        var parameterSeparator = [String]()
        if separations.contains(.parameters),
            let lastLine = parameters.last,
            lastLine != separator,
            (
                !formattedThrows.isEmpty
                || !formattedReturns.isEmpty
            )
        {
            parameterSeparator = [separator]
        }

        var throwsSeparator = [String]()
        if separations.contains(.throws),
            let lastLine = formattedThrows.last,
            lastLine != separator,
            !formattedReturns.isEmpty
        {
            throwsSeparator = [separator]
        }

        return [
            description,
            descriptionSeparator,
            paramHeader,
            parameters,
            parameterSeparator,
            formattedThrows,
            throwsSeparator,
            formattedReturns
        ].flatMap { $0 }
    }
}

// Fold a line of text with natural language breaks until it fits in a colmun
// limit.
func fold(line: String, byLimit limit: Int) -> [String] {
    assert(limit > 0, "attempt to reflow text to by a non-positive limit: \(limit)")

    var remainder = line[...]
    var result = [String]()
    while remainder.count > limit {
        let segmentEnd = remainder.index(remainder.startIndex, offsetBy: limit)
        var cursor = segmentEnd
        while cursor > remainder.startIndex && remainder[cursor] != " " {
            cursor = remainder.index(before: cursor)
        }

        // Didn't find a good point to break in this segment, we need to look
        // forward until one is found and form a line from start of the segment
        // til there.
        if cursor == remainder.startIndex {
            cursor = segmentEnd
            while cursor < remainder.endIndex && remainder[cursor] != " " {
                cursor = remainder.index(after: cursor)
            }
        }

        result.append(String(remainder[..<cursor]))

        if cursor < remainder.endIndex, remainder[cursor] == " " {
            cursor = remainder.index(after: cursor)
        }

        remainder = remainder[cursor...]
    }

    if !remainder.isEmpty {
        result.append(String(remainder))
    }
    return result
}
