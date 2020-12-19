import Models
import XCTest
@testable import Editor

final class DocStringReturnsFormattingTests: XCTestCase {
    func testFormattingBasicReturns() {
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

        XCTAssertEqual(
            result,
            [
                "/// - Returns: description for returns."
            ]
        )
    }

    func testFormattingBasicReturnsWithMissingColon() {
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
                hasColon: false,
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
            separations: []
        )

        XCTAssertEqual(
            result,
            [
                "/// - Returns: description for returns."
            ]
        )
    }

    func testFormattingLowercaseKeyword() {
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
            throws: nil)

        let result = doc.reformat(
            initialColumn: 0,
            columnLimit: 100,
            verticalAlign: false,
            alignAfterColon: [],
            firstLetterUpperCase: false,
            parameterStyle: .whatever,
            separations: []
        )

        XCTAssertEqual(
            result,
            [
                "/// - returns: description for returns."
            ]
        )
    }

    func testFormattingColumnLimitWithAlignAfterColon() {
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
            throws: nil)

        let result = doc.reformat(
            initialColumn: 8,
            columnLimit: 45,
            verticalAlign: false,
            alignAfterColon: [.returns],
            firstLetterUpperCase: true,
            parameterStyle: .whatever,
            separations: []
        )

        XCTAssertEqual(
            result,
            [
                "/// - Returns: description for",
                "///            returns."
            ]
        )
    }

    func testFormattingColumnLimitWithoutAlignAfterColon() {
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
            throws: nil)

        let result = doc.reformat(
            initialColumn: 8,
            columnLimit: 45,
            verticalAlign: false,
            alignAfterColon: [],
            firstLetterUpperCase: true,
            parameterStyle: .whatever,
            separations: []
        )

        XCTAssertEqual(
            result,
            [
                "/// - Returns: description for",
                "/// returns."
            ]
        )
    }
    func testFormattingColumnLimitPreservesLeadingWhitespaces() {
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
                    .init(" ", "description for returns."),
                    .init("   ", "line 2 description for returns."),
                ]),
            throws: nil)

        let result = doc.reformat(
            initialColumn: 8,
            columnLimit: 44,
            verticalAlign: false,
            alignAfterColon: [],
            firstLetterUpperCase: true,
            parameterStyle: .whatever,
            separations: []
        )

        XCTAssertEqual(
            result,
            [
                "/// - Returns: description for",
                "/// returns.",
                "///   line 2 description for",
                "///   returns.",
            ]
        )
    }

    func testFormattingColumnLimitRemoveExcessLeadingSpaceBeforeColon() {
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
                    .init(" ", "description for returns."),
                    .init("   ", "line 2 description for returns."),
                ]),
            throws: nil)

        let result = doc.reformat(
            initialColumn: 8,
            columnLimit: 44,
            verticalAlign: false,
            alignAfterColon: [.returns],
            firstLetterUpperCase: true,
            parameterStyle: .whatever,
            separations: []
        )

        XCTAssertEqual(
            result,
            [
                "/// - Returns: description for",
                "///            returns.",
                "///            line 2 description",
                "///            for returns.",
            ]
        )
    }
}
