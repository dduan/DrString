import Chalk
import Critic
import Pathos

private extension DocProblem.Detail {
    private func actualWhitespace(_ actual: String) -> String {
        actual.isEmpty ? "none" : "\(actual, background: .cyan)"
    }

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
            return "Parameter \(name, color: .green) should start with exactly \(expected, color: .cyan) space\(expected > 1 ? "s" : "") before \("-", color: .green), found \(actualWhitespace(actual))"
        case .spaceBetweenDashAndParameterKeyword(let actual, let keyword, let name):
            return "\(name, color: .green) should have exactly 1 space between \("-", color: .green) and \(keyword, color: .green), found \(actualWhitespace(actual))"
        case .spaceBeforeParameterName(let actual, let keyword, let name):
            return "There should be exactly 1 space between \(keyword, color: .green) and \(name, color: .green), found \(actualWhitespace(actual))"
        case .spaceBeforeColon(let actual, let name):
            return "For \(name, color: .green), there should be no whitespace before \(":", color: .green), found \(actual, background: .cyan)"
        case .preDashSpace(let keyword, let actual):
            return "\(keyword, color: .green) should start with exactly 1 space before \("-", color: .green), found \(actualWhitespace(actual))"
        case .spaceBetweenDashAndKeyword(let keyword, let actual):
            return "There should be exactly 1 space between \("-", color: .green) and \(keyword, color: .green), found \(actualWhitespace(actual))"
        case .verticalAlignment(let expected, let nameOrKeyword, let line):
            return "Line \(line, color: .green) of \(nameOrKeyword, color: .green)'s description is not properly vertically aligned (should have \(expected, color: .green) leading spaces)"
        case .spaceAfterColon(let keyword, let actual):
            return "For \(keyword, color: .green), there should be exactly 1 space after \(":", color: .green), found \(actualWhitespace(actual))"
        case .keywordCasingForParameter(let actual, let expected, let name):
            return "For \(name, color: .green), \(expected, color: .green) is misspelled as \(actual, color: .cyan)"
        case .keywordCasing(let actual, let expected):
            return "\(expected, color: .green) is misspelled as \(actual, color: .cyan)"
        case .descriptionShouldEndWithEmptyLine:
            return "Overall description should end with an empty line"
        case .sectionShouldEndWithEmptyLine(let keywordOrName):
            return "\(keywordOrName, color: .green)'s description should end with an empty line"
        case .redundantKeyword(let keyword):
            return "Redundant documentation for \(keyword, color: .green)"
        case .redundantTextFollowingParameterHeader(let keyword):
            return "\(":", color: .green) should be the last character on the line for \(keyword, color: .green)"
        case .excludedYetNoProblemIsFound(let configFile):
            let exclusionHint = " in \(configFile ?? "a command line argument")"
            return "This file is explicitly excluded\(exclusionHint), but it has no docstring problems (except for this)."
        case .excludedYetNotIncluded:
            return "This file is explicitly excluded, but it's not included for checking anyways."
        case .parametersAreNotGrouped:
            return "Parameters are organized in the \("separate", color: .green) style, but \("grouped", color: .green) style is preferred."
        case .parametersAreNotSeparated:
            return "Parameters are organized in the \("grouped", color: .green) style, but \("separate", color: .green) style is preferred."
        case .missingColon(let name):
            return "\(name, color: .green) should be followed by a \(":", color: .green) character."
        case .invalidPattern(let type, let configFile):
            let source = "\(configFile ?? "a command line argument")"
            return "Could not find any files matching this \(type) pattern specified in \(source)."
        }
    }

    private var id: String { "\(self.explainerID, color: .blue)" }

    var fullDescription: String { "|\(self.id)| \(self.description) " }
}

private extension DocProblem {
    var description: String {
        let count = self.details.count
        let pluralPostfix = count > 1 ? "s" : ""
        let path = (try? Path(self.filePath).absolute()).map { "\($0)" } ?? self.filePath
        let subjectClause = self.docName.isEmpty ? "" : " regarding \(self.docName, color: .green)"
        let headerText = "\(path):\(self.line + 1):\(self.column): \("warning", color: .yellow): \(count) docstring problem\(pluralPostfix)\(subjectClause)"
        let header = "\(headerText, style: .bold)"
        return ([header] + self.details.map { $0.fullDescription }).joined(separator: "\n")
    }
}

public func ttyText(for docProblem: DocProblem) -> String {
    return docProblem.description
}
