import XCTest
import FileCheck
@testable import DrStringCore

final class InvalidPatternTests: XCTestCase {
    private let directory: String = { "/" + #file.split(separator: "/").dropLast().joined(separator: "/") }()

    private func runTest(expectation: String, include: [String], exclude: [String]) -> Bool {
        let include = include.map { self.directory + "/Fixtures/" + "\($0).fixture" }
        let exclude = exclude.map { self.directory + "/Fixtures/" + "\($0).fixture" }
        return fileCheckOutput(against: .buffer(expectation), options: .allowEmptyInput) {
            var config = Configuration()
            config.includedPaths = include
            config.excludedPaths = exclude
            _ = try? check(with: config, configFile: nil)
        }
    }

    func testInvalidPatternForInclusionIsReported() {
        let expect = """
        // CHECK: Could not find any files matching this inclusion pattern
        """
        XCTAssert(self.runTest(expectation: expect, include: ["_iDoNotExist_"], exclude: []))
    }

    func testValidPatternForInclusionIsNotReported() {
        let expect = """
        // CHECK-NOT: Could not find any files matching this inclusion pattern
        """
        XCTAssert(self.runTest(expectation: expect, include: ["complete"], exclude: []))
    }

    func testInvalidPatternForExclusionIsReported() {
        let expect = """
        // CHECK: Could not find any files matching this inclusion pattern
        """
        XCTAssert(self.runTest(expectation: expect, include: [], exclude: ["_iDoNotExist_"]))
    }

    func testValidPatternForExclusionIsNotReported() {
        let expect = """
        // CHECK-NOT: Could not find any files matching this inclusion pattern
        """
        XCTAssert(self.runTest(expectation: expect, include: ["*"], exclude: ["complete"]))
    }
}
