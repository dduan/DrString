import Models
@testable import Critic
import XCTest

final class ThrowsTests: XCTestCase {
    func testAlignAfterColonIsNotAProblem() {
        let throwsDoc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [],
            returns: nil,
            throws: .init(
                preDashWhitespaces: " ",
                keyword: .init(" ", "Throws"),
                name: .init("", ""),
                preColonWhitespace: "",
                hasColon: true,
                description: [
                    .init(" ", "start"),
                    .init("            ", "next line")
                ]))
        let problems = findThrowsProblems(ignoreThrows: false, doesThrow: true, throwsDoc,
                                          firstLetterUpper: true, needsSeparation: false,
                                          alignAfterColon: true)
        XCTAssert(problems.isEmpty)
    }

    func testAlignBeforeColonIsAProblem() {
        let throwsDoc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [],
            returns: nil,
            throws: .init(
                preDashWhitespaces: " ",
                keyword: .init(" ", "Throws"),
                name: .init("", ""),
                preColonWhitespace: "",
                hasColon: true,
                description: [
                    .init(" ", "start"),
                    .init("   ", "next line")
                ]))
        let problems = findThrowsProblems(ignoreThrows: false, doesThrow: true, throwsDoc,
                                          firstLetterUpper: true, needsSeparation: false,
                                          alignAfterColon: true)

        guard case .some(.verticalAlignment(11, "Throws", 2)) = problems.first else {
            XCTFail("expected vertical aligment problem")
            return
        }
    }

    func testMissingColonIsAProblem() {
        let throwsDoc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [],
            returns: nil,
            throws: .init(
                preDashWhitespaces: " ",
                keyword: .init(" ", "Throws"),
                name: .init("", ""),
                preColonWhitespace: "",
                hasColon: false,
                description: [
                    .init(" ", "start"),
                ]))
        let problems = findThrowsProblems(ignoreThrows: false, doesThrow: true, throwsDoc,
                                          firstLetterUpper: true, needsSeparation: false,
                                          alignAfterColon: true)
        guard case .some(.missingColon("Throws")) = problems.first else {
            XCTFail("expected missing colon to be a problem")
            return
        }
    }
}
