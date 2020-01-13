import XCTest
import Editor
import Models

final class ReturnsPlaceholderTests: XCTestCase {
    private func formatFunction(rawDoc: [String], returnType: String?, ignore: Bool) -> [String] {
        Documentable(
            path: "",
            startLine: 0,
            startColumn: 0,
            endLine: 0,
            name: "f",
            docLines: rawDoc,
            children: [],
            details: .function(
                throws: false,
                returnType: returnType,
                parameters: []
            )
        ).format(
            columnLimit: nil,
            verticalAlign: false,
            alignAfterColon: [],
            firstLetterUpperCase: true,
            parameterStyle: .separate,
            separations: [],
            ignoreThrows: false,
            ignoreReturns: ignore,
            addPlaceholder: true
        ).first?.text ?? []
    }

    func testGeneratingReturnsNotNecessary() {
        let result = formatFunction(
            rawDoc: [
                "/// Description",
                "/// - Returns: return doc",
            ],
            returnType: "Int",
            ignore: false
        )

        XCTAssertTrue(result.isEmpty)
    }

    func testGeneratingReturnsIgnored() {
        let doc = [
            "/// Description",
        ]

        let result = formatFunction(
            rawDoc: doc,
            returnType: "Int",
            ignore: true
        )

        XCTAssertTrue(result.isEmpty)
    }

    func testNotGeneratingReturns() {
        let result = formatFunction(
            rawDoc: [
                "/// Description",
            ],
            returnType: nil,
            ignore: false
        )

        XCTAssertTrue(result.isEmpty)
    }

    func testGeneratingReturns() {
        let result = formatFunction(
            rawDoc: [
                "/// Description",
            ],
            returnType: "Int",
            ignore: false
        )

        XCTAssertEqual(
            result,
            [
                "/// Description",
                "/// - Returns: <#Int#>"
            ]
        )
    }
}
