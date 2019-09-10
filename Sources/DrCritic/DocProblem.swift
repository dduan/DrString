import DrCrawler
import DrDecipher

public struct DocProblem {
    let existingDocs: ExistingDocs
    let details: [Detail]

    public enum Detail {
        case redundantParameter(String)
        case missingParameter(String, String)
    }
}

extension DocProblem.Detail: CustomStringConvertible {
    public var description: String {
        switch self {
        case .redundantParameter(let name):
            return "  redundant docs for argument '\(name)'"
        case .missingParameter(let name, let type):
            return "  missing docs for argument '\(name)' of type '\(type)'"
        }
    }
}

extension DocProblem: CustomStringConvertible {
    public var description: String {
        let header = "Warning: docstring problems found in \(self.existingDocs.filePath):\(self.existingDocs.line):\(self.existingDocs.column)"
        return ([header] + self.details.map { $0.description }).joined(separator: "\n")
    }
}
