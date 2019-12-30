@testable import Critic
@testable import Decipher
@testable import Crawler
import XCTest

final class ParametersTests: XCTestCase {
    func testMissingColonInParameterEntryIsReported() throws {
        let parameterName = "name"
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", parameterName),
                    preColonWhitespace: "",
                    hasColon: false,
                    description: [
                        .init(" ", "this is a parameter"),
                    ]
                )
            ],
            returns: nil,
            throws: nil)
        let problems = try findParameterProblems(
            [
                Parameter(
                    label: nil,
                    name: parameterName,
                    type: "String",
                    isVariadic: false,
                    hasDefault: false
                )],
            doc,
            true,
            needsSeparation: false,
            verticalAlign: false,
            style: .separate,
            alignAfterColon: false)

        guard case .some(.missingColon(let name)) = problems.first, name == parameterName else {
            XCTFail("Expected problem is not reported")
            return
        }
    }

    func testMissingColonInHeaderIsReported() throws {
        let doc = DocString(
            description: [],
            parameterHeader: .init(
                preDashWhitespaces: " ",
                keyword: .init(" ", "Parameters"),
                name: .init("", ""),
                preColonWhitespace: "",
                hasColon: false,
                description: []
            ),
            parameters: [],
            returns: nil,
            throws: nil)
        let problems = try findParameterProblems(
            [],
            doc,
            true,
            needsSeparation: false,
            verticalAlign: false,
            style: .grouped,
            alignAfterColon: false)

        guard case .some(.missingColon(let keyword)) = problems.first, keyword == "Parameters" else {
            XCTFail("Expected problem is not reported")
            return
        }
    }
}
