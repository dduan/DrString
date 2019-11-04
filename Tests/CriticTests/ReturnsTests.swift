@testable import Critic
@testable import Decipher
import XCTest

final class ReturnsTests: XCTestCase {
    func testAlignAfterColonIsNotAProblem() {
        let returnDoc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [],
            returns: .init(
                preDashWhitespaces: " ",
                keyword: .init(" ", "Returns"),
                name: .init("", ""),
                preColonWhitespace: "",
                description: [
                .init(" ", "start"),
                .init("            ", "next line")
                ]),
            throws: nil)
        let problems = findReturnsProblems(ignoreReturns: false, returnDoc, returnType: "Int", firstLetterUpper: true,
                                           alignAfterColon: true)
        XCTAssert(problems.isEmpty)
    }

    func testAlignBeforeColonIsAProblem() {
        let returnDoc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [],
            returns: .init(
                preDashWhitespaces: " ",
                keyword: .init(" ", "Returns"),
                name: .init("", ""),
                preColonWhitespace: "",
                description: [
                    .init(" ", "start"),
                    .init("    ", "next line")
                ]),
            throws: nil)
        let problems = findReturnsProblems(ignoreReturns: false, returnDoc, returnType: "Int", firstLetterUpper: true,
                                           alignAfterColon: true)

        guard case .some(.verticalAlignment(12, "Returns", 2)) = problems.first else {
            XCTFail("expected vertical aligment problem")
            return
        }
    }
}
