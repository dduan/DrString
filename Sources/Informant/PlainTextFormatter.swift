import Critic
import Pathos

private extension DocProblem.Detail {
    private func actualWhitespace(_ actual: String) -> String {
        actual.isEmpty ? "none" : "`\(actual)`"
    }

    private var description: String {
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
        case .spaceBetweenDashAndParameterKeyword(let actual, let keyword, let name):
            return "`\(name)` should have exactly 1 space between `-` and `\(keyword)`, found \(actualWhitespace(actual))"
        case .spaceBeforeParameterName(let actual, let keyword, let name):
            return "There should be exactly 1 space between `\(keyword)` and `\(name)`, found \(actualWhitespace(actual))"
        case .spaceBeforeColon(let actual, let name):
            return "For `\(name)`, there should be no whitespace before `:`, found `\(actual)`"
        case .preDashSpace(let keyword, let actual):
            return "`\(keyword)` should start with exactly 1 space before `-`, found \(actualWhitespace(actual))"
        case .spaceBetweenDashAndKeyword(let keyword, let actual):
            return "There should be exactly 1 space between `-` and `\(keyword)`, found \(actualWhitespace(actual))"
        case .verticalAlignment(let expected, let nameOrKeyword, let line):
            return "Line \(line) of `\(nameOrKeyword)`'s description is not properly vertically aligned (should have \(expected) leading spaces)"
        case .spaceAfterColon(let keyword, let actual):
            return "For `\(keyword)`, there should be exactly 1 space after `:`, found \(actualWhitespace(actual))"
        case .keywordCasingForParameter(let actual, let expected, let name):
            return "For `\(name)`, `\(expected)` is misspelled as `\(actual)`"
        case .keywordSpelling(let actual, let expected):
            return "`\(expected)` is misspelled as `\(actual)`"
        case .descriptionShouldEndWithEmptyLine:
            return "Overall description should end with an empty line"
        case .sectionShouldEndWithEmptyLine(let keywordOrName):
            return "`\(keywordOrName)`'s description should end with an empty line"
        case .redundantKeyword(let keyword):
            return "Redundant documentation for `\(keyword)`"
        case .redundantTextFollowingParameterHeader(let keyword):
            return "`:` should be the last character on the line for `\(keyword)`"
        case .excludedYetNoProblemIsFound(let configFile):
            let exclusionHint = " in \(configFile ?? "a command line argument")"
            return "This file is explicitly excluded\(exclusionHint), but it has no docstring problems (except for this)."
        case .excludedYetNotIncluded:
            return "This file is explicitly excluded, but it's not included for checking anyways."
        case .parametersAreNotGrouped:
            return "Parameters are organized in the \"separate\" style, but \"grouped\" style is preferred."
        case .parametersAreNotSeparated:
            return "Parameters are organized in the \"grouped\" style, but \"separate\" style is preferred."
        case .missingColon(let name):
            return "`\(name)` should be followed by a `:` character."
        case .invalidPattern(let type, let configFile):
            let source = "\(configFile ?? "a command line argument")"
            return "Could not find any files matching this \(type) pattern specified in \(source)."
        }
    }

    var fullDescription: String { "|\(self.explainerID)| \(self.description) " }
}

private extension DocProblem {
    var description: String {
        let path = (try? Path(self.filePath).absolute()).map { "\($0)" } ?? self.filePath
        return "\(path):\(self.line + 1):\(self.column): warning: \(self.detail.fullDescription)"
    }
}

public func plainText(for docProblem: DocProblem) -> String {
    return docProblem.description
}

let kExplainerSeparator = "\n------------------------------------\n"
let kExplainerBorder = "\n====================================\n"


private extension Explainer {
    var description: String {
        [
            "\n========== DrString \(self.id) ===========\n",
            "Summary:\(kExplainerSeparator)\(self.summary)\(kExplainerSeparator)",
            self.wrongExample.map { "Bad example:\(kExplainerSeparator)\($0)\(kExplainerSeparator)" },
            self.rightExample.map { "Good example:\(kExplainerSeparator)\($0)\(kExplainerSeparator)" },
        ]
            .compactMap { $0 }
            .joined(separator: "\n")
        + kExplainerBorder
    }
}

public func plainText(for explainer: Explainer) -> String {
    return explainer.description
}
