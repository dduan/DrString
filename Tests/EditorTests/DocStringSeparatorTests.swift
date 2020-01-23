import Models
@testable import Editor
import XCTest

final class DocStringSeparatorTests: XCTestCase {
    func testAddsMissingSeparatorAfterDescription() {
        let doc = DocString(
            description: [
                .init(" ", "Description")
            ],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "a"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "a line 1")
                    ])
            ],
            returns:nil,
            throws: nil)

        let result = doc.reformat(
            initialColumn: 0,
            columnLimit: 100,
            verticalAlign: false,
            alignAfterColon: [],
            firstLetterUpperCase: true,
            parameterStyle: .whatever,
            separations: [.description]
        )

        let expectation = [
            "/// Description",
            "///",
            "/// - Parameter a: a line 1",
        ]

        XCTAssertEqual(result, expectation)
    }

    func testDoesNotAddSeparatorAfterDescriptionIfNotNecessary() {
        let doc = DocString(
            description: [
                .init(" ", "Description"),
                .init("", ""),
            ],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "a"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "a line 1")
                    ])
            ],
            returns:nil,
            throws: nil)

        let result = doc.reformat(
            initialColumn: 0,
            columnLimit: 100,
            verticalAlign: false,
            alignAfterColon: [],
            firstLetterUpperCase: true,
            parameterStyle: .whatever,
            separations: [.description]
        )

        let expectation = [
            "/// Description",
            "///",
            "/// - Parameter a: a line 1",
        ]

        XCTAssertEqual(result, expectation)
    }

    func testDoesNotAddSeparatorAfterDescriptionIfNotRequired() {
        let doc = DocString(
            description: [
                .init(" ", "Description"),
            ],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "a"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "a line 1")
                    ])
            ],
            returns:nil,
            throws: nil)

        let result = doc.reformat(
            initialColumn: 0,
            columnLimit: 100,
            verticalAlign: false,
            alignAfterColon: [],
            firstLetterUpperCase: true,
            parameterStyle: .whatever,
            separations: []
        )

        let expectation = [
            "/// Description",
            "/// - Parameter a: a line 1",
        ]

        XCTAssertEqual(result, expectation)
    }

    func testAddsMissingSeparatorAfterParameters() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "a"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "a line 1")
                    ])
            ],
            returns: .init(
                preDashWhitespaces: " ",
                keyword: .init(" ", "Returns"),
                name: .init(" ", ""),
                preColonWhitespace: "",
                hasColon: true,
                description: [
                    .init(" ", "stuff")
                ]),
            throws: nil)

        let result = doc.reformat(
            initialColumn: 0,
            columnLimit: 100,
            verticalAlign: false,
            alignAfterColon: [],
            firstLetterUpperCase: true,
            parameterStyle: .whatever,
            separations: [.parameters]
        )

        let expectation = [
            "/// - Parameter a: a line 1",
            "///",
            "/// - Returns: stuff"
        ]

        XCTAssertEqual(result, expectation)
    }

    func testDoesNotAddSeparatorAfterParametersIfNotNecessary() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "a"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "a line 1"),
                        .init("", ""),
                    ])
            ],
            returns: .init(
                preDashWhitespaces: " ",
                keyword: .init(" ", "Returns"),
                name: .init(" ", ""),
                preColonWhitespace: "",
                hasColon: true,
                description: [
                    .init(" ", "stuff")
                ]),
            throws: nil)

        let result = doc.reformat(
            initialColumn: 0,
            columnLimit: 100,
            verticalAlign: false,
            alignAfterColon: [],
            firstLetterUpperCase: true,
            parameterStyle: .whatever,
            separations: [.parameters]
        )

        let expectation = [
            "/// - Parameter a: a line 1",
            "///",
            "/// - Returns: stuff",
        ]

        XCTAssertEqual(result, expectation)
    }

    func testDoesNotAddSeparatorAfterParametersIfNotRequired() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "a"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "a line 1"),
                    ])
            ],
            returns: .init(
                preDashWhitespaces: " ",
                keyword: .init(" ", "Returns"),
                name: .init(" ", ""),
                preColonWhitespace: "",
                hasColon: true,
                description: [
                    .init(" ", "stuff")
                ]),
            throws: nil)

        let result = doc.reformat(
            initialColumn: 0,
            columnLimit: 100,
            verticalAlign: false,
            alignAfterColon: [],
            firstLetterUpperCase: true,
            parameterStyle: .whatever,
            separations: []
        )

        let expectation = [
            "/// - Parameter a: a line 1",
            "/// - Returns: stuff",
        ]

        XCTAssertEqual(result, expectation)
    }
    func testAddsMissingSeparatorAfterThrows() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [],
            returns: .init(
                preDashWhitespaces: " ",
                keyword: .init(" ", "Returns"),
                name: .init(" ", ""),
                preColonWhitespace: "",
                hasColon: true,
                description: [
                    .init(" ", "stuff")
                ]),
            throws: .init(
                preDashWhitespaces: " ",
                keyword: .init(" ", "Throws"),
                name: .init(" ", ""),
                preColonWhitespace: "",
                hasColon: true,
                description: [
                    .init(" ", "stuff")
                ])
            )

        let result = doc.reformat(
            initialColumn: 0,
            columnLimit: 100,
            verticalAlign: false,
            alignAfterColon: [],
            firstLetterUpperCase: true,
            parameterStyle: .whatever,
            separations: [.throws]
        )

        let expectation = [
            "/// - Throws: stuff",
            "///",
            "/// - Returns: stuff"
        ]

        XCTAssertEqual(result, expectation)
    }

    func testDoesNotAddSeparatorAfterThrowsIfNotNecessary() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [],
            returns: .init(
                preDashWhitespaces: " ",
                keyword: .init(" ", "Returns"),
                name: .init(" ", ""),
                preColonWhitespace: "",
                hasColon: true,
                description: [
                    .init(" ", "stuff"),
                ]),
            throws: .init(
                preDashWhitespaces: " ",
                keyword: .init(" ", "Throws"),
                name: .init(" ", ""),
                preColonWhitespace: "",
                hasColon: true,
                description: [
                    .init(" ", "stuff"),
                    .init("", ""),
                ])
            )

        let result = doc.reformat(
            initialColumn: 0,
            columnLimit: 100,
            verticalAlign: false,
            alignAfterColon: [],
            firstLetterUpperCase: true,
            parameterStyle: .whatever,
            separations: [.throws]
        )

        let expectation = [
            "/// - Throws: stuff",
            "///",
            "/// - Returns: stuff"
        ]

        XCTAssertEqual(result, expectation)
    }

    func testDoesNotAddSeparatorAfterThrowsIfNotRequired() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [],
            returns: .init(
                preDashWhitespaces: " ",
                keyword: .init(" ", "Returns"),
                name: .init(" ", ""),
                preColonWhitespace: "",
                hasColon: true,
                description: [
                    .init(" ", "stuff"),
                ]),
            throws: .init(
                preDashWhitespaces: " ",
                keyword: .init(" ", "Throws"),
                name: .init(" ", ""),
                preColonWhitespace: "",
                hasColon: true,
                description: [
                    .init(" ", "stuff"),
                ])
            )

        let result = doc.reformat(
            initialColumn: 0,
            columnLimit: 100,
            verticalAlign: false,
            alignAfterColon: [],
            firstLetterUpperCase: true,
            parameterStyle: .whatever,
            separations: []
        )

        let expectation = [
            "/// - Throws: stuff",
            "/// - Returns: stuff"
        ]

        XCTAssertEqual(result, expectation)
    }
}
