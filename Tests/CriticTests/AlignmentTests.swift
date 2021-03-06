import Models
@testable import Critic
import XCTest

final class AlignmentTests: XCTestCase {
    func testContinuationLineWithOneSpaceIndentMissingForVerticalAlign() throws {
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
                    hasColon: true,
                    description: [
                        .init(" ", "this is a parameter"),
                             // - parameter name:
                        .init("                  ", "second line"),
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
            verticalAlign: true,
            style: .separate,
            alignAfterColon: false)

        guard case .some(.verticalAlignment) = problems.first?.1 else {
            XCTFail("expected a missing space to be a problem")
            return
        }
    }
}
