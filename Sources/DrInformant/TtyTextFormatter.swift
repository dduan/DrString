import Chalk
import DrCritic

private extension DocProblem.Detail {
    var description: String {
        switch self {
        case .redundantParameter(let name):
            return "Unrecognized docstring for \(name, color: .green)"
        case .missingParameter(let name, let type):
            return "Missing docstring for \(name, color: .green) of type \(type, color: .cyan)"
        case .missingThrow:
            return "Missing docstring for throws"
        case .missingReturn(let type):
            return "Missing docstring for return type \(type, color: .cyan)"
        case .wrongPreDashSpaceInParameter(let expected, let actual, let name):
            return "Parameter \(name, color: .green) should start with exactly \(String(expected), color: .cyan) space\(expected > 1 ? "s" : "") before \("-", color: .green), found \(actual, background: .cyan)"
        }
    }
}

private extension DocProblem {
    var description: String {
        let count = self.details.count
        let pluralPostfix = count > 1 ? "s" : ""
        let headerText = "\(self.filePath):\(self.line):\(self.column): \("warning", color: .yellow): \(count) docstring problem\(pluralPostfix) regarding \(self.docName, color: .green)"
        let header = "\(headerText, style: .bold)"
        let detailPrefix = " - "
        return ([header] + self.details.map { detailPrefix + $0.description }).joined(separator: "\n")
    }
}

public func ttyText(for docProblem: DocProblem) -> String {
    return docProblem.description
}
