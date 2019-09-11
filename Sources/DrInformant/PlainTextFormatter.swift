import DrCritic

extension DocProblem.Detail: CustomStringConvertible {
    public var description: String {
        switch self {
        case .redundantParameter(let name):
            return "redundant docs for argument '\(name)'"
        case .missingParameter(let name, let type):
            return "missing docs for argument '\(name)' of type '\(type)'"
        case .missingThrow:
            return "missing docs for throws"
        case .missingReturns(let type):
            return "missing docs for return of type '\(type)'"
        }
    }
}

extension DocProblem: CustomStringConvertible {
    public var description: String {
        let header = "\(self.filePath):\(self.line):\(self.column): warning: docstring problems regarding `\(self.docName)`"
        let detailPrefix = " • "
        return ([header] + self.details.map { detailPrefix + $0.description }).joined(separator: "\n")
    }
}
