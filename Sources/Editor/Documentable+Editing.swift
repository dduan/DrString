import Crawler
import Decipher

extension Documentable {
    public func format(
        columnLimit: Int?,
        verticalAlign: Bool,
        alignAfterColon: [Section],
        firstLetterUpperCase: Bool,
        parameterStyle: ParameterStyle,
        separations: [Section]
    ) -> [Edit]
    {
        guard case .function = self.details, !self.docLines.isEmpty,
            let docs = try? parse(lines: self.docLines) else
        {
            return []
        }

        let formatted = docs.reformat(
            initialColumn: self.column,
            columnLimit: columnLimit,
            verticalAlign: verticalAlign,
            alignAfterColon: alignAfterColon,
            firstLetterUpperCase: firstLetterUpperCase,
            parameterStyle: parameterStyle,
            separations: separations)

        if formatted != self.docLines {
            let padding = String(Array(repeating: " ", count: self.column))
            return [
                Edit(
                    startingLine: self.line - self.docLines.count,
                    endingLine: self.line,
                    text: formatted.map { padding + $0 })
            ]
        } else {
            return []
        }
    }
}
