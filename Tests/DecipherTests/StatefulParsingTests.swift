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
            parameters: [
                .init(
                    preDashWhitespaces: "   ",
                    keyword: nil,
                    name: .init(" ", "d"),
                    preColonWhitespace: "",
                    description: [
                        .init(" ", "d description")
                    ]
                ),
                .init(
                    preDashWhitespaces: "   ",
                    keyword: nil,
                    name: .init(" ", "c"),
                    preColonWhitespace: "",
                    description: [
                        .init(" ", "c description")
                    ]
                ),
                .init(
                    preDashWhitespaces: "   ",
                    keyword: nil,
                    name: .init(" ", "b"),
                    preColonWhitespace: "",
                    description: [
                        .init(" ", "b description")
                    ]
                ),
                .init(
                    preDashWhitespaces: "   ",
                    keyword: nil,
                    name: .init(" ", "a"),
                    preColonWhitespace: "",
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
                description: [.init(" ", "Returns description")]
            ),
            throws: .init(
                preDashWhitespaces: " ",
                keyword: .init(" ", "Throws"),
                name: .empty,
                preColonWhitespace: "",
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
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "d"),
                    preColonWhitespace: "",
                    description: [
                        .init(" ", "d description")
                    ]
                ),
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "c"),
                    preColonWhitespace: "",
                    description: [
                        .init(" ", "c description")
                    ]
                ),
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "b"),
                    preColonWhitespace: "",
                    description: [
                        .init(" ", "b description")
                    ]
                ),
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "a"),
                    preColonWhitespace: "",
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
                description: [.init(" ", "Returns description")]
            ),
            throws: .init(
                preDashWhitespaces: " ",
                keyword: .init(" ", "Throws"),
                name: .empty,
                preColonWhitespace: "",
                description: [.init(" ", "Throws description")]
            )
        )

        let actual = try parse(lines: text.split(separator: "\n").map(String.init))

        XCTAssertEqual(actual, expected)
    }
}
