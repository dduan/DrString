import FileCheck
import DrStringCore
import XCTest

final class EmptyPatternsTests: XCTestCase {
    private let directory: String = { "/" + #file.split(separator: "/").dropLast().joined(separator: "/") }()

    private func runTest(expectation: String, include: [String], exclude: [String], allowEmpty: Bool) -> Bool {
        let include = include.map { self.directory + "/Fixtures/" + "\($0).fixture" }
        let exclude = exclude.map { self.directory + "/Fixtures/" + "\($0).fixture" }
        return fileCheckOutput(against: .buffer(expectation), options: .allowEmptyInput) {
            var config = Configuration()
            config.includedPaths = include
            config.excludedPaths = exclude
            config.allowEmptyPatterns = allowEmpty
            _ = try? check(with: config, configFile: nil)
        }
    }

    func testEmptyPatternForExclusionIsReportedWhenItsNotAllowed() {
        let expect = """
            // CHECK: Could not find any files matching this
            """
        XCTAssert(self.runTest(expectation: expect, include: ["*"], exclude: ["_doesnotexist_/*"], allowEmpty: false))
    }

    func testEmptyPatternForExclusionIsNotReportedWhenItsAllowed() {
        let expect = """
            // CHECK-NOT: Could not find any files matching this
            """
        XCTAssert(self.runTest(expectation: expect, include: ["*"], exclude: ["_doesnotexist_/*"], allowEmpty: true))
    }
}
