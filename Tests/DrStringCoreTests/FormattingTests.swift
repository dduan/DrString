import DrStringCore
import Pathos
import XCTest

final class FormattingTests: XCTestCase {
    private let directory = Path(#file).parent

    func testFormatPatchesFilesProperly0() throws {
        try Path.withTemporaryDirectory { path in
            for fileName in ["source0", "source1", "expectation0", "expectation1"] {
                try! self.directory.joined(with: "Fixtures", "Formatting", "\(fileName).fixture")
                    .copy(to: path.joined(with: "\(fileName).swift"))
            }

            var config = Configuration()
            config.includedPaths = ["\(path + "source0.swift")", "\(path + "source1.swift")"]
            config.verticalAlignParameterDescription = true
            config.parameterStyle = .separate
            config.columnLimit = 100

            try format(with: config)

            XCTAssertEqual(
                try! (path + "source0.swift").readUTF8String(),
                try! (path + "expectation0.swift").readUTF8String()
            )
            XCTAssertEqual(
                try! (path + "source1.swift").readUTF8String(),
                try! (path + "expectation1.swift").readUTF8String()
            )
        }
    }

    private func verify(sourceName: String, expectationName: String, file: StaticString = #file, line: UInt = #line) throws {
        try Path.withTemporaryDirectory { path in
            for fileName in [sourceName, expectationName] {
                try! self.directory.joined(with: "Fixtures", "Formatting", "\(fileName).fixture")
                    .copy(to: path + "\(fileName).swift")
            }

            var config = Configuration()
            config.includedPaths = ["\(path + "\(sourceName).swift")"]
            config.verticalAlignParameterDescription = true
            config.parameterStyle = .separate
            config.columnLimit = 100
            try format(with: config)

            XCTAssertEqual(
                try! (path + "\(sourceName).swift").readUTF8String(),
                try! (path + "\(expectationName).swift").readUTF8String(),
                file: file, line: line
            )
        }
    }

    func testFormatPatchesFilesProperly1() throws {
        try self.verify(sourceName: "source2", expectationName: "expectation2", file: #file, line: #line)
    }

    func testFormatPatchesFilesProperly2() throws {
        try self.verify(sourceName: "source4", expectationName: "expectation4", file: #file, line: #line)
    }

    func testFormatHandlesEmptyDocstringItemsCorrectly() throws {
        try self.verify(sourceName: "emptyitem", expectationName: "emptyitem_expectation", file: #file, line: #line)
    }

    func testBug192() throws {
        try self.verify(sourceName: "source192", expectationName: "expectation192", file: #file, line: #line)
    }
}
