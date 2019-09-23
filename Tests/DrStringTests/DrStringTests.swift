import DrString
import FileCheck
import XCTest

final class DrStringTests: XCTestCase {
    private let directory: String = { "/" + #file.split(separator: "/").dropLast().joined(separator: "/") }()

    private func runTest(fileName: String, ignoreThrows: Bool = false, expectEmpty: Bool = false) -> Bool {
        let fixture = self.directory + "/Fixtures/" + "\(fileName).swift"
        return fileCheckOutput(against: .filePath(fixture), options: expectEmpty ? .allowEmptyInput : []) {
            _ = checkCommand.run(Configuration(
                includedPaths: [fixture],
                excludedPaths: [],
                options: .init(ignoreDocstringForThrows: ignoreThrows, outputFormat: .plain)))
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
}
