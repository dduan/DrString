import Foundation
import SwiftSyntax

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
        let parameters = node.parameters
        let signatureText = node.identifier.description
            + "(\(parameters.reduce("") { $0 + ($1.label ?? $1.name) + ":" }))"
        let finding = Documentable(
            path: location.file,
            line: location.line,
            column: location.column,
            name: signatureText,
            docLines: node.leadingTrivia?.docStringLines ?? [],
            children: [],
            details: .function(
                isDiscardable: node.isDiscardable,
                throws: node.throws,
                returnType: node.returnType,
                parameters: parameters)
        )
        self.findings.append(finding)
        return node
    }
}
