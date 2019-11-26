import Pathos
import SwiftSyntax

public func extractDocs(fromSourcePath sourcePath: String) throws -> ([Documentable], String) {
    let extractor = try DocExtractor(filePath: sourcePath)
    return (try extractor.extractDocs(), extractor.source)
}

private final class DocExtractor: SyntaxRewriter {
    private var findings: [Documentable] = []
    private let syntax: SourceFileSyntax
    private let converter: SourceLocationConverter

    let source: String

    init(filePath: String) throws {
        let sourceText = try readString(atPath: filePath)
        self.source = sourceText
        let tree = try SyntaxParser.parse(source: sourceText)
        self.syntax = tree
        self.converter = SourceLocationConverter(file: filePath, source: sourceText)
    }

    func extractDocs() throws -> [Documentable] {
        _ = self.visit(syntax)
        return self.findings
    }

    override func visit(_ node: FunctionDeclSyntax) -> DeclSyntax {
        let location = node.startLocation(converter: self.converter)
        let parameters = node.parameters
        let signatureText = node.identifier.description
            + "(\(parameters.reduce("") { $0 + ($1.label ?? $1.name) + ":" }))"
        let finding = Documentable(
            path: location.file ?? "",
            line: (location.line ?? 0) - 1,
            column: (location.column ?? 0) - 1,
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

    override func visit(_ node: InitializerDeclSyntax) -> DeclSyntax {
        let location = node.startLocation(converter: self.converter)
        let parameters = node.parameters.parameterList.map { $0.parameter }
        let signatureText = "init(\(parameters.reduce("") { $0 + ($1.label ?? $1.name) + ":" }))"
        let finding = Documentable(
            path: location.file ?? "",
            line: (location.line ?? 0) - 1,
            column: (location.column ?? 0) - 1,
            name: signatureText,
            docLines: node.leadingTrivia?.docStringLines ?? [],
            children: [],
            details: .function(
                throws: false,
                returnType: nil,
                parameters: parameters)
        )
        self.findings.append(finding)
        return node
    }
}
