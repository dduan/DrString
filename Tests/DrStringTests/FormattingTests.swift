import DrString
import Pathos
import XCTest

final class FormattingTests: XCTestCase {
    private let directory: String = {
        "/" + #file.split(separator: "/").dropLast().joined(separator: "/")
    }()

    func testFormatPatchesFilesProperly0() throws {
        try withTemporaryDirectory { path in
            for fileName in ["source0", "source1", "expectation0", "expectation1"] {
                try! copyFile(
                    fromPath: join(paths: self.directory, "Fixtures", "Formatting", "\(fileName).fixture"),
                    toPath: join(paths: path, "\(fileName).swift"))
            }

            format(with: .init(
                includedPaths: [join(paths: path, "source0.swift"), join(paths: path, "source1.swift")],
                excludedPaths: [],
                ignoreDocstringForThrows: false,
                ignoreDocstringForReturns: false,
                verticalAlignParameterDescription: true,
                superfluousExclusion: false,
                firstKeywordLetter: .uppercase,
                outputFormat: .automatic,
                separatedSections: [],
                parameterStyle: .separate,
                alignAfterColon: [],
                columnLimit: 100))
            XCTAssertEqual(
                try! readString(atPath: join(paths: path, "source0.swift")),
                try! readString(atPath: join(paths: path, "expectation0.swift"))
            )
            XCTAssertEqual(
                try! readString(atPath: join(paths: path, "source1.swift")),
                try! readString(atPath: join(paths: path, "expectation1.swift"))
            )
        }
    }

    private func verify(sourceName: String, expectationName: String, file: StaticString = #file, line: UInt = #line) throws {
        try withTemporaryDirectory { path in
            for fileName in [sourceName, expectationName] {
                try! copyFile(
                    fromPath: join(paths: self.directory, "Fixtures", "Formatting", "\(fileName).fixture"),
                    toPath: join(paths: path, "\(fileName).swift"))
            }

            format(with: .init(
                includedPaths: [join(paths: path, "\(sourceName).swift")],
                excludedPaths: [],
                ignoreDocstringForThrows: false,
                ignoreDocstringForReturns: false,
                verticalAlignParameterDescription: true,
                superfluousExclusion: false,
                firstKeywordLetter: .uppercase,
                outputFormat: .automatic,
                separatedSections: [],
                parameterStyle: .separate,
                alignAfterColon: [],
                columnLimit: 100))

            XCTAssertEqual(
                try! readString(atPath: join(paths: path, "\(sourceName).swift")),
                try! readString(atPath: join(paths: path, "\(expectationName).swift")),
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
}
