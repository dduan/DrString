import DrString
import XCTest
import FileCheck

final class SuperfluousExclusionTests: XCTestCase {
    private let directory: String = { "/" + #file.split(separator: "/").dropLast().joined(separator: "/") }()

    private func runTest(expectation: String, include: [String], exclude: [String], allowSuperfluousExclusion: Bool) -> Bool {
        let include = include.map { self.directory + "/Fixtures/" + "\($0).fixture" }
        let exclude = exclude.map { self.directory + "/Fixtures/" + "\($0).fixture" }
        return fileCheckOutput(against: .buffer(expectation), options: .allowEmptyInput) {
            var config = Configuration()
            config.includedPaths = include
            config.excludedPaths = exclude
            config.allowSuperfluousExclusion = allowSuperfluousExclusion
            config.firstKeywordLetter = .lowercase
            config.columnLimit = 100
            _ = check(with: config, configFile: ".drstring.toml")
        }
    }

    func testAllowSuperfluousExclusion() {
        XCTAssert(runTest(
            expectation: "// CHECK-NOT: This file is explicitly excluded in .drstring.toml, but it has no docstring problem",
            include: ["complete"],
            exclude: ["complete"],
            allowSuperfluousExclusion: true)
        )
    }

    func testNoSuperfluousExclusion() {
        XCTAssert(runTest(
            expectation: "// CHECK-NOT: This file is explicitly excluded .drstring.toml, but it has no docstring problem",
            include: ["badParamFormat"],
            exclude: ["badReturnsFormat"],
            allowSuperfluousExclusion: false)
        )
    }

    func testNormalExclusionIsNotSuperfluous() {
        XCTAssert(runTest(
            expectation: "// CHECK-NOT: This file is explicitly excluded .drstring.toml, but it has no docstring problem",
            include: ["badParamFormat", "badReturnsFormat"],
            exclude: ["badReturnsFormat"],
            allowSuperfluousExclusion: false)
        )
    }

    func testYesSuperfluousExclusion() {
        let expectation = """
        // CHECK: complete
        // CHECK: This file is explicitly excluded in .drstring.toml, but it has no docstring problem
        """

        XCTAssert(runTest(
            expectation: expectation,
            include: ["complete", "badParametersKeyword"],
            exclude: ["complete", "badParametersKeyword"],
            allowSuperfluousExclusion: false)
        )
    }

    func testSuperfluousExclusionViaGlob() {
        XCTAssert(runTest(
            expectation: "// CHECK-NOT: This file is explicitly excluded in .drstring.toml, but it has no docstring problem",
            include: ["badParamFormat"],
            exclude: ["*omplete"],
            allowSuperfluousExclusion: false)
        )
    }

    func testSuperfluousExclusionBecauseItsNotIncludedToBeginWith() {
        let expectation = """
        // CHECK: badParamFormat
        // CHECK: This file is explicitly excluded, but it's not included for checking anyways
        """

        XCTAssert(runTest(
            expectation: expectation,
            include: ["badReturnsFormat"],
            exclude: ["badParamFormat"],
            allowSuperfluousExclusion: false)
        )
    }
}
