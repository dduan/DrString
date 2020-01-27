import XCTest
import Editor
import Models

final class ThrowsPlaceholderTests: XCTestCase {
    private func formatFunction(rawDoc: [String], doesThrow: Bool, ignore: Bool) -> [String] {
        Documentable(
            path: "",
            startLine: 0,
            startColumn: 0,
            endLine: 0,
            name: "f",
            docLines: rawDoc,
            children: [],
            details: .function(
                throws: doesThrow,
                returnType: nil,
                parameters: []
            )
        ).format(
            columnLimit: nil,
            verticalAlign: false,
            alignAfterColon: [],
            firstLetterUpperCase: true,
            parameterStyle: .separate,
            separations: [],
            ignoreThrows: ignore,
            ignoreReturns: false,
            addPlaceholder: true,
            startLine: nil,
            endLine: nil
        ).first?.text ?? []
    }

    func testGeneratingThrowsNotNecessary() {
        let result = formatFunction(
            rawDoc: [
                "/// Description",
                "/// - Throws: throw doc",
            ],
            doesThrow: true,
            ignore: false
        )

        XCTAssertTrue(result.isEmpty)
    }

    func testGeneratingThrowsIgnored() {
        let doc = [
            "/// Description",
        ]

        let result = formatFunction(
            rawDoc: doc,
            doesThrow: true,
            ignore: true
        )

        XCTAssertTrue(result.isEmpty)
    }

    func testNotGeneratingThrows() {
        let result = formatFunction(
            rawDoc: [
                "/// Description",
            ],
            doesThrow: false,
            ignore: false
        )

        XCTAssertTrue(result.isEmpty)
    }

    func testGeneratingThrows() {
        let result = formatFunction(
            rawDoc: [
                "/// Description",
            ],
            doesThrow: true,
            ignore: false
        )

        XCTAssertEqual(
            result,
            [
                "/// Description",
                "/// - Throws: <#Error#>"
            ]
        )
    }
}
