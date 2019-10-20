import DrString
import XCTest
import FileCheck

final class SuperfluousExclusionTests: XCTestCase {
    private let directory: String = { "/" + #file.split(separator: "/").dropLast().joined(separator: "/") }()

    private func runTest(expectation: String, include: [String], exclude: [String], allowSuperfluousExclusion: Bool) -> Bool {
        let include = include.map { self.directory + "/Fixtures/" + "\($0).swift" }
        let exclude = exclude.map { self.directory + "/Fixtures/" + "\($0).swift" }
        return fileCheckOutput(against: .buffer(expectation), options: .allowEmptyInput) {
            _ = check(with: Configuration(
                includedPaths: include,
                excludedPaths: exclude,
                ignoreDocstringForThrows: false,
                ignoreDocstringForReturns: false,
                verticalAlignParameterDescription: false,
                superfluousExclusion: allowSuperfluousExclusion,
                firstKeywordLetter: .lowercase,
                outputFormat: .plain,
                separatedSections: [])
            )
        }
    }

    func testAllowSuperfluousExclusion() {
        XCTAssert(runTest(
            expectation: "// CHECK-NOT: This file is explicitly excluded, but it has no docstring problem",
            include: ["complete"],
            exclude: ["complete"],
            allowSuperfluousExclusion: true)
        )
    }

    func testNoSuperfluousExclusion() {
        XCTAssert(runTest(
            expectation: "// CHECK-NOT: This file is explicitly excluded, but it has no docstring problem",
            include: ["badParamFormat"],
            exclude: ["badReturnsFormat"],
            allowSuperfluousExclusion: false)
        )
    }

    func testNormalExclusionIsNotSuperfluous() {
        XCTAssert(runTest(
            expectation: "// CHECK-NOT: This file is explicitly excluded, but it has no docstring problem",
            include: ["badParamFormat", "badReturnsFormat"],
            exclude: ["badReturnsFormat"],
            allowSuperfluousExclusion: false)
        )
    }

    func testYesSuperfluousExclusion() {
        let expectation = """
        // CHECK: complete.swift
        // CHECK: This file is explicitly excluded, but it has no docstring problem
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
            expectation: "// CHECK-NOT: This file is explicitly excluded, but it has no docstring problem",
            include: ["badParamFormat"],
            exclude: ["*omplete"],
            allowSuperfluousExclusion: false)
        )
    }

    func testSuperfluousExclusionBecauseItsNotIncludedToBeginWith() {
        let expectation = """
        // CHECK: badParamFormat.swift
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
