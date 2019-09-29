import DrString
import FileCheck
import XCTest
import Critic

final class DrStringTests: XCTestCase {
    private let directory: String = { "/" + #file.split(separator: "/").dropLast().joined(separator: "/") }()

    private func runTest(
        fileName: String,
        ignoreThrows: Bool = false,
        verticalAlign: Bool = true,
        expectEmpty: Bool = false,
        firstLetter: Configuration.FirstKeywordLetterCasing = .whatever,
        needsSeparation: [Section] = []
    ) -> Bool {
        let fixture = self.directory + "/Fixtures/" + "\(fileName).swift"
        return fileCheckOutput(against: .filePath(fixture), options: expectEmpty ? .allowEmptyInput : []) {
            _ = checkCommand.run(
                Configuration(
                    includedPaths: [fixture],
                    excludedPaths: [],
                    options: .init(
                        ignoreDocstringForThrows: ignoreThrows,
                        verticalAlignParameterDescription: verticalAlign,
                        firstKeywordLetter: firstLetter,
                        outputFormat: .plain,
                        separatedSections: needsSeparation)),
                []
            )
        }
    }

    func testCompletelyDocumentedFunction() throws {
        XCTAssert(runTest(fileName: "complete", expectEmpty: true))
    }

    func testNoDocNoError() throws {
        XCTAssert(runTest(fileName: "nodoc", expectEmpty: true))
    }

    func testMissingStuff() throws {
        XCTAssert(runTest(fileName: "missingStuff"))
    }

    func testIgnoreThrows() throws {
        XCTAssert(runTest(fileName: "ignoreThrows", ignoreThrows: true))
    }

    func testBadParameterFormat() throws {
        XCTAssert(runTest(fileName: "badParamFormat", ignoreThrows: true))
    }

    func testBadThrowsFormat() throws {
        XCTAssert(runTest(fileName: "badThrowsFormat"))
    }

    func testBadReturnsFormat() throws {
        XCTAssert(runTest(fileName: "badReturnsFormat"))
    }

    func testMisalignedParameterDescriptions() throws {
        XCTAssert(runTest(fileName: "misalignedParameterDescription"))
    }

    func testLowercaseKeywords() throws {
        XCTAssert(runTest(fileName: "lowercaseKeywords", firstLetter: .lowercase))
    }

    func testUppercaseKeywords() throws {
        XCTAssert(runTest(fileName: "uppercaseKeywords", firstLetter: .uppercase))
    }

    func testMissingSectionSeparator() throws {
        XCTAssert(runTest(fileName: "missingSectionSeparator", expectEmpty: false,
                          needsSeparation: Section.allCases))
    }
}
