import XCTest
import Editor
import Models

final class ParameterPlaceholderTests: XCTestCase {
    private func formatFunction(rawDoc: [String], parameters: [Parameter]) -> [String] {
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
                returnType: nil,
                parameters: parameters
            )
        ).format(
            columnLimit: nil,
            verticalAlign: false,
            alignAfterColon: [],
            firstLetterUpperCase: true,
            parameterStyle: .separate,
            separations: [],
            ignoreThrows: false,
            ignoreReturns: false,
            addPlaceholder: true,
            startLine: nil,
            endLine: nil
        ).first?.text ?? []
    }

    func testNoPlaceholderNecessary() {
        let doc = [
            "/// description",
            "/// - Parameter a: a",
            "/// - Parameter b: b",
        ]

        let result = formatFunction(
            rawDoc: doc,
            parameters: [
                .init(label: nil, name: "a", type: "Int", isVariadic: false, hasDefault: false),
                .init(label: nil, name: "b", type: "Int", isVariadic: false, hasDefault: false),
            ]
        )

        XCTAssertTrue(result.isEmpty)
    }

    func testGeneratePlaceholderAtBeginning() {
        let doc = [
            "/// description",
            "/// - Parameter b: b",
            "/// - Parameter c: c",
        ]

        let result = formatFunction(
            rawDoc: doc,
            parameters: [
                .init(label: nil, name: "a", type: "Int", isVariadic: false, hasDefault: false),
                .init(label: nil, name: "b", type: "Int", isVariadic: false, hasDefault: false),
                .init(label: nil, name: "c", type: "Int", isVariadic: false, hasDefault: false),
            ]
        )

        XCTAssertEqual(result, [
            "/// description",
            "/// - Parameter a: <#Int#>",
            "/// - Parameter b: b",
            "/// - Parameter c: c",
        ])
    }

    func testGeneratePlaceholderAtEnd() {
        let doc = [
            "/// description",
            "/// - Parameter a: a",
            "/// - Parameter b: b",
        ]

        let result = formatFunction(
            rawDoc: doc,
            parameters: [
                .init(label: nil, name: "a", type: "Int", isVariadic: false, hasDefault: false),
                .init(label: nil, name: "b", type: "Int", isVariadic: false, hasDefault: false),
                .init(label: nil, name: "c", type: "Int", isVariadic: false, hasDefault: false),
            ]
        )

        XCTAssertEqual(result, [
            "/// description",
            "/// - Parameter a: a",
            "/// - Parameter b: b",
            "/// - Parameter c: <#Int#>",
        ])
    }

    func testGeneratePlaceholderAtMiddle() {
        let doc = [
            "/// description",
            "/// - Parameter a: a",
            "/// - Parameter c: c",
        ]

        let result = formatFunction(
            rawDoc: doc,
            parameters: [
                .init(label: nil, name: "a", type: "Int", isVariadic: false, hasDefault: false),
                .init(label: nil, name: "b", type: "Int", isVariadic: false, hasDefault: false),
                .init(label: nil, name: "c", type: "Int", isVariadic: false, hasDefault: false),
            ]
        )

        XCTAssertEqual(result, [
            "/// description",
            "/// - Parameter a: a",
            "/// - Parameter b: <#Int#>",
            "/// - Parameter c: c",
        ])
    }

    func testGeneratePlaceholderAtAnywhereButMiddle() {
        let doc = [
            "/// description",
            "/// - Parameter b: b",
        ]

        let result = formatFunction(
            rawDoc: doc,
            parameters: [
                .init(label: nil, name: "a", type: "Int", isVariadic: false, hasDefault: false),
                .init(label: nil, name: "b", type: "Int", isVariadic: false, hasDefault: false),
                .init(label: nil, name: "c", type: "Int", isVariadic: false, hasDefault: false),
            ]
        )

        XCTAssertEqual(result, [
            "/// description",
            "/// - Parameter a: <#Int#>",
            "/// - Parameter b: b",
            "/// - Parameter c: <#Int#>",
        ])
    }

    func testGeneratePlaceholderWhileKeepingRedundantDoc() {
        let doc = [
            "/// description",
            "/// - Parameter x: x",
            "/// - Parameter b: b",
        ]

        let result = formatFunction(
            rawDoc: doc,
            parameters: [
                .init(label: nil, name: "a", type: "Int", isVariadic: false, hasDefault: false),
                .init(label: nil, name: "b", type: "Int", isVariadic: false, hasDefault: false),
                .init(label: nil, name: "c", type: "Int", isVariadic: false, hasDefault: false),
            ]
        )

        XCTAssertEqual(result, [
            "/// description",
            "/// - Parameter a: <#Int#>",
            "/// - Parameter x: x",
            "/// - Parameter b: b",
            "/// - Parameter c: <#Int#>",
        ])
    }
}
