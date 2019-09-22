import DrString
import FileCheck
import XCTest

final class DrStringTests: XCTestCase {
    private let directory: String = { "/" + #file.split(separator: "/").dropLast().joined(separator: "/") }()

    private func runTest(fileName: String, ignoreThrows: Bool) -> Bool {
        let fixture = self.directory + "/Fixtures/" + "\(fileName).swift"
        return fileCheckOutput(against: .filePath(fixture), options: FileCheckOptions.allowEmptyInput) {
            _ = checkCommand.run(Configuration(
                includedPaths: [fixture],
                excludedPaths: [],
                options: .init(ignoreDocstringForThrows: ignoreThrows, outputFormat: .plain)))
        }
    }

    func testCompletelyDocumentedFunction() throws {
        XCTAssert(runTest(fileName: "complete", ignoreThrows: false))
    }

    func testNoDocNoError() throws {
        XCTAssert(runTest(fileName: "nodoc", ignoreThrows: false))
    }

    func testMissingStuff() throws {
        XCTAssert(runTest(fileName: "missingStuff", ignoreThrows: false))
    }

    func testIgnoreThrows() throws {
        XCTAssert(runTest(fileName: "ignoreThrows", ignoreThrows: true))
    }

    func testBadParameterFormat() throws {
        XCTAssert(runTest(fileName: "badParamFormat", ignoreThrows: true))
    }
}
