import Chalk
import Critic

private extension DocProblem.Detail {
    private var description: String {
        switch self {
        case .redundantParameter(let name):
            return "Unrecognized docstring for \(name, color: .green)"
        case .missingParameter(let name, let type):
            return "Missing docstring for \(name, color: .green) of type \(type, color: .cyan)"
        case .missingThrow:
            return "Missing docstring for throws"
        case .missingReturn(let type):
            return "Missing docstring for return type \(type, color: .cyan)"
        case .preDashSpaceInParameter(let expected, let actual, let name):
            return "Parameter \(name, color: .green) should start with exactly \(String(expected), color: .cyan) space\(expected > 1 ? "s" : "") before \("-", color: .green), found \(actual, background: .cyan)"
        case .spaceBetweenDashAndParamaterKeyword(let actual, let keyword, let name):
            return "\(name, color: .green) should have exactly 1 space between \("-", color: .green) and \(keyword, color: .green), found \(actual, background: .cyan)"
        case .spaceBeforeParameterName(let actual, let keyword, let name):
            return "There should be exactly 1 space between \(keyword, color: .green) and \(name, color: .green), found \(actual, background: .cyan)"
        case .spaceBeforeColon(let actual, let name):
            return "For \(name, color: .green), there should be no whitespace before \(":", color: .green), found \(actual, background: .cyan)"
        case .preDashSpace(let keyword, let actual):
            return "\(keyword, color: .green) should start with exactly 1 space before \("-", color: .green), found \(actual, background: .cyan)"
        case .spaceBetweenDashAndKeyword(let keyword, let actual):
            return "There should be exactly 1 space between \("-", color: .green) and \(keyword, color: .green), found \(actual, background: .cyan)"
        case .verticalAlignment(let expected, let nameOrKeyword, let line):
            return "Line \(line, color: .green) of \(nameOrKeyword, color: .green)'s description is not properly vertically aligned (should have \(expected, color: .green) leading spaces)"
        case .spaceAfterColon(let keyword, let actual):
            return "For \(keyword, color: .green), there should be exactly 1 space after \(":", color: .green), found \(actual, background: .cyan)"
        case .keywordCasingForParameter(let actual, let expected, let name):
            return "For \(name, color: .green), \(expected, color: .green) is misspelled as \(actual, color: .cyan)"
        case .keywordCasing(let actual, let expected):
            return "\(expected, color: .green) is misspelled as \(actual, color: .cyan)"
        }
    }

    private var id: String { "\(self.explainerID, color: .blue)" }

    var fullDescription: String { "[\(self.id)] \(self.description) " }
}

private extension DocProblem {
    var description: String {
        let count = self.details.count
        let pluralPostfix = count > 1 ? "s" : ""
        let headerText = "\(self.filePath):\(self.line):\(self.column): \("warning", color: .yellow): \(count) docstring problem\(pluralPostfix) regarding \(self.docName, color: .green)"
        let header = "\(headerText, style: .bold)"
        return ([header] + self.details.map { $0.fullDescription }).joined(separator: "\n")
    }
}

public func ttyText(for docProblem: DocProblem) -> String {
    return docProblem.description
}
