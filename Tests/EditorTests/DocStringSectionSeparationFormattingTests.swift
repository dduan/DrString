import Models
@testable import Editor
import XCTest

final class DocStringSectionSeparationFormattingTests: XCTestCase {
    func testFormattingEmptyDocString() {
        let doc = DocString(
            location: .init(),
            description: [],
            parameterHeader: nil,
            parameters: [],
            returns: nil,
            throws: nil)
        let result = doc.reformat(
            initialColumn: 0,
            columnLimit: 100,
            verticalAlign: false,
            alignAfterColon: [],
            firstLetterUpperCase: true,
            parameterStyle: .whatever,
            separations: [.description, .parameters, .throws]
        )

        XCTAssertTrue(result.isEmpty)
    }

    func testDescriptionSeparatorGetsAdded() {
        let doc = DocString(
            location: .init(),
            description: [
                .init(" ", "Description"),
            ],
            parameterHeader: nil,
            parameters: [
                .init(
                    relativeLineNumber: 0,
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "foo's description")
                    ])
            ],
            returns: nil,
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

        XCTAssertEqual(
            result,
            [
                "/// Description",
                "///",
                "/// - Parameter foo: foo's description",
            ]
        )
    }

    func testDescriptionSeparatorDoesNotGetAddedIfUnnecessary() {
        let doc = DocString(
            location: .init(),
            description: [
                .init(" ", "Description"),
                .init("", ""),
            ],
            parameterHeader: nil,
            parameters: [
                .init(
                    relativeLineNumber: 0,
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "foo's description")
                    ])
            ],
            returns: nil,
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

        XCTAssertEqual(
            result,
            [
                "/// Description",
                "///",
                "/// - Parameter foo: foo's description",
            ]
        )
    }

    func testDescriptionSeparatorDoesNotGetAddedIfItsTheLastSection() {
        let doc = DocString(
            location: .init(),
            description: [
                .init(" ", "Description"),
            ],
            parameterHeader: nil,
            parameters: [],
            returns: nil,
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

        XCTAssertEqual(
            result,
            [
                "/// Description",
            ]
        )
    }


    func testParameterSeparatorGetsAdded() {
        let doc = DocString(
            location: .init(),
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    relativeLineNumber: 0,
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "foo's description")
                    ])
            ],
            returns: .init(
                relativeLineNumber: 0,
                preDashWhitespaces: " ",
                keyword: .init(" ", "Returns"),
                name: .init("", ""),
                preColonWhitespace: "",
                hasColon: true,
                description: [
                    .init(" ", "description for returns.")
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

        XCTAssertEqual(
            result,
            [
                "/// - Parameter foo: foo's description",
                "///",
                "/// - Returns: description for returns."
            ]
        )
    }

    func testParametersSeparatorDoesNotGetAddedIfUnnecessary() {
        let doc = DocString(
            location: .init(),
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    relativeLineNumber: 0,
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "foo's description"),
                        .init("", ""),
                    ])
            ],
            returns: .init(
                relativeLineNumber: 0,
                preDashWhitespaces: " ",
                keyword: .init(" ", "Returns"),
                name: .init("", ""),
                preColonWhitespace: "",
                hasColon: true,
                description: [
                    .init(" ", "description for returns.")
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

        XCTAssertEqual(
            result,
            [
                "/// - Parameter foo: foo's description",
                "///",
                "/// - Returns: description for returns."
            ]
        )
    }

    func testParameterSeparatorDoesNotGetAddedIfItsTheLastSection() {
        let doc = DocString(
            location: .init(),
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    relativeLineNumber: 0,
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "foo's description"),
                    ])
            ],
            returns: nil,
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

        XCTAssertEqual(
            result,
            [
                "/// - Parameter foo: foo's description",
            ]
        )
    }

    func testThrowsSeparatorGetsAdded() {
        let doc = DocString(
            location: .init(),
            description: [],
            parameterHeader: nil,
            parameters: [],
            returns: .init(
                relativeLineNumber: 0,
                preDashWhitespaces: " ",
                keyword: .init(" ", "Returns"),
                name: .init("", ""),
                preColonWhitespace: "",
                hasColon: true,
                description: [
                    .init(" ", "description for returns.")
                ]),
            throws: .init(
                relativeLineNumber: 0,
                preDashWhitespaces: " ",
                keyword: .init(" ", "Throws"),
                name: .init("", ""),
                preColonWhitespace: "",
                hasColon: true,
                description: [
                    .init(" ", "description for throws.")
                ]))

        let result = doc.reformat(
            initialColumn: 0,
            columnLimit: 100,
            verticalAlign: false,
            alignAfterColon: [],
            firstLetterUpperCase: true,
            parameterStyle: .whatever,
            separations: [.throws]
        )

        XCTAssertEqual(
            result,
            [
                "/// - Throws: description for throws.",
                "///",
                "/// - Returns: description for returns."
            ]
        )
    }

    func testThrowsSeparatorDoesNotGetAddedIfUnnecessary() {
        let doc = DocString(
            location: .init(),
            description: [],
            parameterHeader: nil,
            parameters: [],
            returns: .init(
                relativeLineNumber: 0,
                preDashWhitespaces: " ",
                keyword: .init(" ", "Returns"),
                name: .init("", ""),
                preColonWhitespace: "",
                hasColon: true,
                description: [
                    .init(" ", "description for returns.")
                ]),
            throws: .init(
                relativeLineNumber: 0,
                preDashWhitespaces: " ",
                keyword: .init(" ", "Throws"),
                name: .init("", ""),
                preColonWhitespace: "",
                hasColon: true,
                description: [
                    .init(" ", "description for throws."),
                    .init("", ""),
                ]))

        let result = doc.reformat(
            initialColumn: 0,
            columnLimit: 100,
            verticalAlign: false,
            alignAfterColon: [],
            firstLetterUpperCase: true,
            parameterStyle: .whatever,
            separations: [.throws]
        )

        XCTAssertEqual(
            result,
            [
                "/// - Throws: description for throws.",
                "///",
                "/// - Returns: description for returns."
            ]
        )
    }

    func testThrowsSeparatorDoesNotGetAddedIfItsTheLastSection() {
        let doc = DocString(
            location: .init(),
            description: [],
            parameterHeader: nil,
            parameters: [],
            returns: nil,
            throws: .init(
                relativeLineNumber: 0,
                preDashWhitespaces: " ",
                keyword: .init(" ", "Throws"),
                name: .init("", ""),
                preColonWhitespace: "",
                hasColon: true,
                description: [
                    .init(" ", "description for throws."),
                ]))

        let result = doc.reformat(
            initialColumn: 0,
            columnLimit: 100,
            verticalAlign: false,
            alignAfterColon: [],
            firstLetterUpperCase: true,
            parameterStyle: .whatever,
            separations: [.throws]
        )

        XCTAssertEqual(
            result,
            [
                "/// - Throws: description for throws.",
            ]
        )
    }
}
