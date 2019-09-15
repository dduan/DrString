import DrDecipher
import SwiftSyntax

extension FunctionParameterSyntax {
    var paramater: Parameter {
        let label = self.firstName?.text
        let name = self.secondName?.text ?? self.firstName?.text ?? ""
        let typeTriviaLength = self.type?.trailingTriviaLength.utf8Length ?? 0
        let type = String(((self.type?.description.utf8.dropLast(typeTriviaLength)).flatMap(String.init) ?? "").map { $0 == "\n" ? " " : $0 })
        let hasDefault = self.defaultArgument != nil
        let isVariadic = self.ellipsis?.text == "..."
        return Parameter(label: label, name: name, type: type, isVariadic: isVariadic, hasDefault: hasDefault)
    }
}

extension FunctionDeclSyntax {
    var isDiscardable: Bool {
        return self.attributes?.contains { $0.attributeName.text == "discardableResult" } ?? false
    }

    var `throws`: Bool {
        return self.signature.throwsOrRethrowsKeyword != nil
    }

    var returnType: String? {
        let trailingTrivaLength = self.signature.output?.returnType.trailingTriviaLength.utf8Length ?? 0
        return (self.signature.output?.returnType.description.utf8.dropLast(trailingTrivaLength))
            .flatMap(String.init)
    }

    var parameters: [Parameter] {
        return self.signature.input.parameterList.children.compactMap { syntax in
            return (syntax as? FunctionParameterSyntax)?.paramater
        }
    }
}

extension Trivia {
    var docStringLines: [String] {
        var result = [String]()
        outer: for piece in self.reversed() {
            switch piece {
            case .spaces, .tabs, .verticalTabs:
                continue outer
            case .newlines(let n):
                if n > 1 {
                    break outer
                }
            case .carriageReturns(let n):
                if n > 1 {
                    break outer
                }
            case .carriageReturnLineFeeds(let n):
                if n > 1 {
                    break outer
                }
            case .docLineComment(let s):
                result.append(s)
            default:
                break outer
            }
        }

        return result.reversed()
    }
}
