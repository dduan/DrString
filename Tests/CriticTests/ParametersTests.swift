import Models
@testable import Critic
import XCTest

final class ParametersTests: XCTestCase {
    func testMissingColonInParameterEntryIsReported() throws {
        let parameterName = "name"
        let doc = DocString(
            location: .init(),
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
            fallback: .init(),
            0,
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

        guard case .some(.missingColon(let name)) = problems.first?.1, name == parameterName else {
            XCTFail("Expected problem is not reported")
            return
        }
    }

    func testMissingColonInHeaderIsReported() throws {
        let doc = DocString(
            location: .init(),
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
            fallback: .init(),
            0,
            [],
            doc,
            true,
            needsSeparation: false,
            verticalAlign: false,
            style: .grouped,
            alignAfterColon: false)

        guard case .some(.missingColon(let keyword)) = problems.first?.1, keyword == "Parameters" else {
            XCTFail("Expected problem is not reported")
            return
        }
    }
}
