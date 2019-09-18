import DrString
import FileCheck
import XCTest

final class DrStringTests: XCTestCase {
    let parentDirectory: String = {
        "/" + #file.split(separator: "/").dropLast().joined(separator: "/")
    }()

    func fixture(named name: String) -> String {
        parentDirectory + "/Fixtures/" + name
    }

    func testCompletelyDocumentedFunction() throws {
        XCTAssert(fileCheckOutput(options: FileCheckOptions.allowEmptyInput) {
            checkCommand.run(Configuration(
                includedPaths: [self.fixture(named: "complete.swift")],
                excludedPaths: [],
                options: .init(ignoreDocstringForThrows: false, outputFormat: .plain)))

            // CHECK-NOT: docstring problem
        })
    }

    func testNoDocNoError() throws {
        XCTAssert(fileCheckOutput(options: FileCheckOptions.allowEmptyInput) {
            checkCommand.run(Configuration(
                includedPaths: [self.fixture(named: "nodoc.swift")],
                excludedPaths: [],
                options: .init(ignoreDocstringForThrows: false, outputFormat: .plain)))

            // CHECK-NOT: docstring problem
        })
    }

    func testMissingStuff() throws {
        XCTAssert(fileCheckOutput(withPrefixes: ["MISSING-STUFF"]) {
            checkCommand.run(Configuration(
                includedPaths: [self.fixture(named: "missingStuff.swift")],
                excludedPaths: [],
                options: .init(ignoreDocstringForThrows: false, outputFormat: .plain)))

            // MISSING-STUFF: 4 docstring problems
            // MISSING-STUFF: Missing docstring for `t0i1` of type `Int`
            // MISSING-STUFF: Unrecognized docstring for `random`
            // MISSING-STUFF: Missing docstring for throws
            // MISSING-STUFF: Missing docstring for return type `String`
        })
    }

    func testIgnoreThrows() throws {
        XCTAssert(fileCheckOutput(withPrefixes: ["IGNORE-THROWS"]) {
            checkCommand.run(Configuration(
                includedPaths: [self.fixture(named: "ignoreThrows.swift")],
                excludedPaths: [],
                options: .init(ignoreDocstringForThrows: true, outputFormat: .plain)))

            // IGNORE-THROWS: 3 docstring problems
            // IGNORE-THROWS: Missing docstring for `t0i1` of type `Int`
            // IGNORE-THROWS: Unrecognized docstring for `random`
            // IGNORE-THROWS-NOT: Missing docstring for throws
            // IGNORE-THROWS: Missing docstring for return type `String`
        })
    }
}
