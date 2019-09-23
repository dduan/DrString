import Pathos
import SwiftSyntax

public func extractDocs(fromSourcePath sourcePath: String) throws -> [Documentable] {
    return try DocExtractor(filePath: sourcePath).extractDocs()
}

private final class DocExtractor: SyntaxRewriter {
    private var findings: [Documentable] = []
    private let source: SourceFileSyntax
    private let converter: SourceLocationConverter

    init(filePath: String) throws {
        let sourceText = try readString(atPath: filePath)
        let tree = try SyntaxParser.parse(source: sourceText)
        self.source = tree
        self.converter = SourceLocationConverter(file: filePath, source: sourceText)
    }

    func extractDocs() throws -> [Documentable] {
        _ = self.visit(source)
        return self.findings
    }

    override func visit(_ node: FunctionDeclSyntax) -> DeclSyntax {
        let location = node.startLocation(converter: self.converter)
        let parameters = node.parameters
        let signatureText = node.identifier.description
            + "(\(parameters.reduce("") { $0 + ($1.label ?? $1.name) + ":" }))"
        let finding = Documentable(
            path: location.file ?? "",
            line: location.line ?? 0,
            column: location.column ?? 0,
            name: signatureText,
            docLines: node.leadingTrivia?.docStringLines ?? [],
            children: [],
            details: .function(
                throws: node.throws,
                returnType: node.returnType,
                parameters: parameters)
        )
        self.findings.append(finding)
        return node
    }
}
