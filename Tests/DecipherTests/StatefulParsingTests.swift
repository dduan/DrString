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
            description: [
                .init(" ", "Overall description"),
                .empty,
            ],
            parameterHeader: .init(
                preDashWhitespaces: " ",
                keyword: .init(" ", "Parameters"),
                name: .init("", ""),
                preColonWhitespace: "",
                hasColon: true,
                description: []
            ),
            parameters: [
                .init(
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
                preDashWhitespaces: " ",
                keyword: .init(" ", "Returns"),
                name: .empty,
                preColonWhitespace: "",
                hasColon: true,
                description: [.init(" ", "Returns description")]
            ),
            throws: .init(
                preDashWhitespaces: " ",
                keyword: .init(" ", "Throws"),
                name: .empty,
                preColonWhitespace: "",
                hasColon: true,
                description: [.init(" ", "Throws description")]
            )
        )

        let actual = try parse(lines: text.split(separator: "\n").map(String.init))

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
            description: [
                .init(" ", "Overall description"),
                .empty
            ],
            parameterHeader: nil,
            parameters: [
                .init(
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
                preDashWhitespaces: " ",
                keyword: .init(" ", "Returns"),
                name: .empty,
                preColonWhitespace: "",
                hasColon: true,
                description: [.init(" ", "Returns description")]
            ),
            throws: .init(
                preDashWhitespaces: " ",
                keyword: .init(" ", "Throws"),
                name: .empty,
                preColonWhitespace: "",
                hasColon: true,
                description: [.init(" ", "Throws description")]
            )
        )

        let actual = try parse(lines: text.split(separator: "\n").map(String.init))

        XCTAssertEqual(actual, expected)
    }
}
