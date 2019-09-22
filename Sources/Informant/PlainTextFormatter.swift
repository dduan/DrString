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
        case .wrongPreDashSpaceInParameter(let expected, let actual, let name):
            return "Parameter `\(name)` should start with exactly \(expected) space\(expected > 1 ? "s" : "") before `-`, found `\(actual)`"
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
