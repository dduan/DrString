@testable import DrDecipher
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
                "Overall description",
                ""
            ],
            parameters: [
                DocString.Parameter(
                    name: "d",
                    description: [
                        "d description"
                    ]
                ),
                DocString.Parameter(
                    name: "c",
                    description: [
                        "c description"
                    ]
                ),
                DocString.Parameter(
                    name: "b",
                    description: [
                        "b description"
                    ]
                ),
                DocString.Parameter(
                    name: "a",
                    description: [
                        "a description",
                        "a description continues"
                    ]
                ),
            ],
            returns: ["Returns description"],
            throws: ["Throws description"])

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
                "Overall description",
                ""
            ],
            parameters: [
                DocString.Parameter(
                    name: "d",
                    description: [
                        "d description"
                    ]
                ),
                DocString.Parameter(
                    name: "c",
                    description: [
                        "c description"
                    ]
                ),
                DocString.Parameter(
                    name: "b",
                    description: [
                        "b description"
                    ]
                ),
                DocString.Parameter(
                    name: "a",
                    description: [
                        "a description",
                        "a description continues"
                    ]
                ),
                ],
            returns: ["Returns description"],
            throws: ["Throws description"])

        let actual = try parse(lines: text.split(separator: "\n").map(String.init))

        XCTAssertEqual(actual, expected)
    }
}
