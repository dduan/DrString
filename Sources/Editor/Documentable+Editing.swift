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
