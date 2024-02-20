import Models
import SwiftSyntax

extension FunctionParameterSyntax {
    var parameter: Parameter {
        let label = self.firstName.text
        let name = self.secondName?.text ?? self.firstName.text
        let type = self.type.description
        let hasDefault = self.defaultValue != nil
        let isVariadic = self.ellipsis?.text == "..."
        return Parameter(label: label, name: name, type: type, isVariadic: isVariadic, hasDefault: hasDefault)
    }
}

extension FunctionDeclSyntax {
    var `throws`: Bool {
        return self.signature.effectSpecifiers?.throwsSpecifier != nil
    }

    var returnType: String? {
        let trailingTrivaLength = self.signature.returnClause?.type.trailingTriviaLength.utf8Length ?? 0
        return (self.signature.returnClause?.type.description.utf8.dropLast(trailingTrivaLength))
            .flatMap(String.init)
    }

    var parameters: [Parameter] {
        return self.signature.parameterClause.parameters.children(viewMode: .sourceAccurate).compactMap { syntax in
            return FunctionParameterSyntax(syntax)?.parameter
        }
    }
}

extension InitializerDeclSyntax {
    var `throws`: Bool {
        return self.signature.effectSpecifiers?.throwsSpecifier != nil
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
