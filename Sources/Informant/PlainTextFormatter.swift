import Critic

private extension DocProblem.Detail {
    var description: String {
        switch self {
        case .redundantParameter(let name):
            return "Unrecognized docstring for `\(name)`"
        case .missingParameter(let name, let type):
            return "Missing docstring for `\(name)` of type `\(type)`"
        case .missingThrow:
            return "Missing docstring for throws"
        case .missingReturn(let type):
            return "Missing docstring for return type `\(type)`"
        case .preDashSpaceInParameter(let expected, let actual, let name):
            return "Parameter `\(name)` should start with exactly \(expected) space\(expected > 1 ? "s" : "") before `-`, found `\(actual)`"
        case .spaceBetweenDashAndParamaterKeyword(let actual, let keyword, let name):
            return "`\(name)` should have exactly 1 space between `-` and `\(keyword)`, found `\(actual)`"
        case .keywordSpellingForParameter(let actual, let expected, let name):
            return "`\(name)` should be proceeded by `\(expected)`, found `\(actual)`"
        case .spaceBeforeParameterName(let actual, let keyword, let name):
            return "There should be exactly 1 space between `\(keyword)` and `\(name)`, found `\(actual)`"
        case .spaceBeforeColon(let actual, let name):
            return "For `\(name)`, there should be no whitespace before `:`, found `\(actual)`"
        case .preDashSpace(let keyword, let actual):
            return "`\(keyword)` should start with exactly 1 space before `-`, found `\(actual)`"
        case .spaceBetweenDashAndKeyword(let keyword, let actual):
            return "There should be exactly 1 space between `-` and `\(keyword)`, found `\(actual)`"
        case .verticalAlignment(let expected, let nameOrKeyword, let line):
            return "Line \(line) of `\(nameOrKeyword)`'s description is not properly vertically aligned (should have \(expected) leading spaces)"
        case .spaceAfterColon(let keyword, let actual):
            return "For `\(keyword)`, there should be exactly 1 space after `:`, found `\(actual)`"
        }
    }
}

private extension DocProblem {
    var description: String {
        let count = self.details.count
        let pluralPostfix = count > 1 ? "s" : ""
        let header = "\(self.filePath):\(self.line):\(self.column): warning: \(count) docstring problem\(pluralPostfix) regarding `\(self.docName)`"
        let detailPrefix = " - "
        return ([header] + self.details.map { detailPrefix + $0.description }).joined(separator: "\n")
    }
}

public func plainText(for docProblem: DocProblem) -> String {
    return docProblem.description
}
