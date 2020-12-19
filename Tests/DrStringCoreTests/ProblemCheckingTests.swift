import DrStringCore
import FileCheck
import XCTest
import Models

final class ProblemCheckingTests: XCTestCase {
    private let directory: String = { "/" + #file.split(separator: "/").dropLast().joined(separator: "/") }()

    private func runTest(
        fileName: String,
        ignoreThrows: Bool = false,
        ignoreReturns: Bool = false,
        verticalAlign: Bool = true,
        alignAfterColon: [Section] = [],
        expectEmpty: Bool = false,
        firstLetter: Configuration.FirstKeywordLetterCasing = .uppercase,
        needsSeparation: [Section] = [],
        parameterStyle: ParameterStyle = .whatever,
        format: Configuration.OutputFormat = .plain
    ) -> Bool {
        let fixture = self.directory + "/Fixtures/" + "\(fileName).fixture"
        var config = Configuration()
        config.includedPaths = [fixture]
        config.ignoreDocstringForThrows = ignoreThrows
        config.ignoreDocstringForReturns = ignoreReturns
        config.verticalAlignParameterDescription = verticalAlign
        config.firstKeywordLetter = firstLetter
        config.outputFormat = format
        config.separatedSections = needsSeparation
        config.parameterStyle = parameterStyle
        config.alignAfterColon = alignAfterColon
        config.columnLimit = 100
        return fileCheckOutput(against: .filePath(fixture), options: expectEmpty ? .allowEmptyInput : []) {
            _ = try? check(with: config, configFile: ".drstring.toml")
        }
    }

    func testCompletelyDocumentedFunction() throws {
        XCTAssert(runTest(fileName: "complete", expectEmpty: true, firstLetter: .lowercase))
    }

    func testNoDocNoError() throws {
        XCTAssert(runTest(fileName: "nodoc", expectEmpty: true))
    }

    func testMissingStuff() throws {
        XCTAssert(runTest(fileName: "missingStuff", firstLetter: .lowercase))
    }

    func testIgnoreThrows() throws {
        XCTAssert(runTest(fileName: "ignoreThrows", ignoreThrows: true, firstLetter: .lowercase))
    }

    func testIgnoreReturns() throws {
        XCTAssert(runTest(fileName: "ignoreReturns", ignoreReturns: true, firstLetter: .lowercase))
    }

    func testBadParameterFormat() throws {
        XCTAssert(runTest(fileName: "badParamFormat", ignoreThrows: true))
    }

    func testBadThrowsFormat() throws {
        XCTAssert(runTest(fileName: "badThrowsFormat"))
    }

    func testBadReturnsFormat() throws {
        XCTAssert(runTest(fileName: "badReturnsFormat"))
    }

    func testMisalignedParameterDescriptions() throws {
        XCTAssert(runTest(fileName: "misalignedParameterDescription"))
    }

    func testLowercaseKeywords() throws {
        XCTAssert(runTest(fileName: "lowercaseKeywords", firstLetter: .lowercase))
    }

    func testUppercaseKeywords() throws {
        XCTAssert(runTest(fileName: "uppercaseKeywords", firstLetter: .uppercase))
    }

    func testMissingSectionSeparator() throws {
        XCTAssert(runTest(fileName: "missingSectionSeparator", expectEmpty: false,
                          needsSeparation: Section.allCases))
    }

    func testRedundantKeywords() throws {
        XCTAssert(runTest(fileName: "redundantKeywords", expectEmpty: false))
    }

    func testRedundantKeywordsPathsOnly() throws {
        XCTAssert(runTest(fileName: "redundantKeywordsPathsOnly", expectEmpty: false, format: .paths))
    }

    func testBadParametersKeywordFormat() throws {
        XCTAssert(runTest(fileName: "badParametersKeyword", expectEmpty: false, firstLetter: .uppercase))
    }

    func testSeparateParameterStyle() throws {
        XCTAssert(runTest(fileName: "separateParameterStyle", expectEmpty: false, parameterStyle: .separate))
    }

    func testGroupedParameterStyle() throws {
        XCTAssert(runTest(fileName: "groupedParameterStyle", expectEmpty: false, parameterStyle: .grouped))
    }

    func testWhateverParameterStyle() throws {
        XCTAssert(runTest(fileName: "whateverParameterStyle", expectEmpty: true, parameterStyle: .whatever))
    }

    func testAlignAfterColon() throws {
        XCTAssert(runTest(fileName: "alignAfterColon", alignAfterColon: [.parameters, .throws, .returns],
                          expectEmpty: false))
    }

    func testAlignAfterColonNotRequired() throws {
        XCTAssert(runTest(fileName: "alignAfterColonNotRequired",
                          alignAfterColon: [.parameters, .throws, .returns], expectEmpty: true))
    }

    func testInitProblemsAreChecked() throws {
        XCTAssert(runTest(fileName: "init"))
    }

    func testInitThrowsIsNotRedundant() throws {
        XCTAssert(runTest(fileName: "140", ignoreThrows: true))
    }

    func testSeparateLineInThrowsIsNotTreatedAsContinuedBody() throws {
        XCTAssert(runTest(fileName: "147", alignAfterColon: [.throws], expectEmpty: true))
    }

    func testProblemPositions() throws {
        XCTAssert(
            runTest(fileName: "positional", alignAfterColon: [.parameters, .returns, .throws],
                    needsSeparation: [.description, .parameters]))
    }
}
