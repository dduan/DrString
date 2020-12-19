import Models
@testable import Decipher
import XCTest

final class StatefulParsingTests: XCTestCase {
    func testNormalGroupedParameterState() throws {
        let text = """
        /// Overall description
        ///
        /// - Parameters:
        ///   - d: d description
        ///   - c: c description
        ///   - b: b description
        ///   - a: a description
        ///        a description continues
        /// - Returns: Returns description
        /// - Throws: Throws description
        """

        let expected = DocString(
            location: .init(path: "", line: 0, column: 0),
            description: [
                .init(" ", "Overall description"),
                .empty,
            ],
            parameterHeader: .init(
                relativeLineNumber: 2,
                preDashWhitespaces: " ",
                keyword: .init(" ", "Parameters"),
                name: .init("", ""),
                preColonWhitespace: "",
                hasColon: true,
                description: []
            ),
            parameters: [
                .init(
                    relativeLineNumber: 3,
                    preDashWhitespaces: "   ",
                    keyword: nil,
                    name: .init(" ", "d"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "d description")
                    ]
                ),
                .init(
                    relativeLineNumber: 4,
                    preDashWhitespaces: "   ",
                    keyword: nil,
                    name: .init(" ", "c"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "c description")
                    ]
                ),
                .init(
                    relativeLineNumber: 5,
                    preDashWhitespaces: "   ",
                    keyword: nil,
                    name: .init(" ", "b"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "b description")
                    ]
                ),
                .init(
                    relativeLineNumber: 6,
                    preDashWhitespaces: "   ",
                    keyword: nil,
                    name: .init(" ", "a"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "a description"),
                        .init("        ", "a description continues"),
                    ]
                ),
            ],
            returns: .init(
                relativeLineNumber: 8,
                preDashWhitespaces: " ",
                keyword: .init(" ", "Returns"),
                name: .empty,
                preColonWhitespace: "",
                hasColon: true,
                description: [.init(" ", "Returns description")]
            ),
            throws: .init(
                relativeLineNumber: 9,
                preDashWhitespaces: " ",
                keyword: .init(" ", "Throws"),
                name: .empty,
                preColonWhitespace: "",
                hasColon: true,
                description: [.init(" ", "Throws description")]
            )
        )

        let actual = try parse(location: .init(), lines: text.split(separator: "\n").map(String.init))

        XCTAssertEqual(actual, expected)
    }

    func testNormalSeparateParameterState() throws {
        let text = """
        /// Overall description
        ///
        /// - Parameter d: d description
        /// - Parameter c: c description
        /// - Parameter b: b description
        /// - Parameter a: a description
        ///                a description continues
        /// - Returns: Returns description
        /// - Throws: Throws description
        """

        let expected = DocString(
            location: .init(),
            description: [
                .init(" ", "Overall description"),
                .empty
            ],
            parameterHeader: nil,
            parameters: [
                .init(
                    relativeLineNumber: 2,
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "d"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "d description")
                    ]
                ),
                .init(
                    relativeLineNumber: 3,
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "c"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "c description")
                    ]
                ),
                .init(
                    relativeLineNumber: 4,
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "b"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "b description")
                    ]
                ),
                .init(
                    relativeLineNumber: 5,
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "a"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "a description"),
                        .init("                ", "a description continues")
                    ]
                ),
            ],
            returns: .init(
                relativeLineNumber: 7,
                preDashWhitespaces: " ",
                keyword: .init(" ", "Returns"),
                name: .empty,
                preColonWhitespace: "",
                hasColon: true,
                description: [.init(" ", "Returns description")]
            ),
            throws: .init(
                relativeLineNumber: 8,
                preDashWhitespaces: " ",
                keyword: .init(" ", "Throws"),
                name: .empty,
                preColonWhitespace: "",
                hasColon: true,
                description: [.init(" ", "Throws description")]
            )
        )

        let actual = try parse(location: .init(), lines: text.split(separator: "\n").map(String.init))

        XCTAssertEqual(actual, expected)
    }
}
