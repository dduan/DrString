import DrCritic

extension DocProblem.Detail: CustomStringConvertible {
    public var description: String {
        switch self {
        case .redundantParameter(let name):
            return "Unrecognized docstring for '\(name)'"
        case .missingParameter(let name, let type):
            return "Missing docstring for '\(name)' of type '\(type)'"
        case .missingThrow:
            return "Missing docs for throws"
        case .missingReturn(let type):
            return "Missing docs for return type '\(type)'"
        }
    }
}

extension DocProblem: CustomStringConvertible {
    public var description: String {
        let count = self.details.count
        let pluralPostfix = count > 1 ? "s" : ""
        let header = "\(self.filePath):\(self.line):\(self.column): warning: \(count) docstring problem\(pluralPostfix) regarding `\(self.docName)`"
        let detailPrefix = " - "
        return ([header] + self.details.map { detailPrefix + $0.description }).joined(separator: "\n")
    }
}
