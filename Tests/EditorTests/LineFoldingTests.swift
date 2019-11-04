@testable import Editor
import XCTest

final class LineFoldingTests: XCTestCase {
    func testLineWithinLimitRemains() {
        let smol = "smol text"
        XCTAssertEqual(
            fold(line: smol, byLimit: 60),
            [smol]
        )
    }

    func testLineExceedingLimitFlowsDownward() {
        XCTAssertEqual(
            fold(line: "test test test test test", byLimit: 10),
            [
                "test test",
                "test test",
                "test",
            ]
        )
    }

    func testWordExceedingLimitFormItsOwnLine() {
        XCTAssertEqual(
            fold(line: "test test test_test_test test test", byLimit: 10),
            [
                "test test",
                "test_test_test",
                "test test",
            ]
        )
    }
}
