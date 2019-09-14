import Foundation
import SwiftSyntax

// TODO: Remove dependency on `URL` therefore Foundation when SwiftSyntax updates.
public func extractDocs(fromSourcePath sourcePath: String) throws -> [Documentable] {
    return try DocExtractor(filePath: sourcePath)?.extractDocs() ?? []
}

private final class DocExtractor: SyntaxRewriter {
    private var findings: [Documentable] = []
    private let url: URL

    init?(filePath: String) {
        guard let url = URL(string: filePath) else {
            return nil
        }

        self.url = url
    }

    func extractDocs() throws -> [Documentable] {
        let source = try SyntaxTreeParser.parse(self.url)
        _ = self.visit(source)
        return self.findings
    }

    override func visit(_ node: FunctionDeclSyntax) -> DeclSyntax {
        let location = node.startLocation(in: self.url)
        let signature = node.signature
        let signatureText = signature.description.dropLast(signature.trailingTriviaLength.utf8Length)
        let finding = Documentable(
            path: location.file,
            line: location.line,
            column: location.column,
            name: node.identifier.description + signatureText,
            docLines: node.leadingTrivia?.docStringLines ?? [],
            children: [],
            details: .function(
                isDiscardable: node.isDiscardable,
                throws: node.throws,
                returnType: node.returnType,
                parameters: node.parameters)
        )
        self.findings.append(finding)
        return node
    }
}
