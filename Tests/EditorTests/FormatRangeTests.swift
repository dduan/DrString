import XCTest
import Models
import Editor
@testable import Crawler

private let kContent = """
/// description
func f(a: Int) -> Int {

}

/// description
func g() throws -> Int {

}
"""

private let kGeneratedFDoc = [
    "/// description",
    "/// - Parameter a: <#Int#>",
    "/// - Returns: <#Int#>",
]

private let kGeneratedGDoc = [
    "/// description",
    "/// - Throws: <#Error#>",
    "/// - Returns: <#Int#>",
]

private extension Documentable {
    func formatAt(start: Int?, end: Int?) -> [Edit] {
        self.format(
            columnLimit: 0,
            verticalAlign: false,
            alignAfterColon: [],
            firstLetterUpperCase: true,
            parameterStyle: .whatever,
            separations: [],
            ignoreThrows: false,
            ignoreReturns: false,
            addPlaceholder: true,
            startLine: start,
            endLine: end)
    }
}

final class FormatRangeTests: XCTestCase {
    private var functionF: Documentable!
    private var functionG: Documentable!

    override func setUp() {
        super.setUp()
        let documentables = (try? DocExtractor(sourceText: kContent, sourcePath: nil)
            .extractDocs()) ?? []
        self.functionF = documentables[0]
        self.functionG = documentables[1]
    }

    func testAt_0_0() throws {
        let result = functionF.formatAt(start: 0, end: 0)
        guard result.count == 1 else {
            XCTFail("Expected 1 edit")
            return
        }

        let edit = result[0]
        XCTAssertEqual(edit.text, kGeneratedFDoc)
    }

    func testAt_0_1() throws {
        let result = functionF.formatAt(start: 0, end: 1)
        guard result.count == 1 else {
            XCTFail("Expected 1 edit")
            return
        }

        let edit = result[0]
        XCTAssertEqual(edit.text, kGeneratedFDoc)
    }

    func testAt_0_3() throws {
        let result = functionF.formatAt(start: 0, end: 3)
        guard result.count == 1 else {
            XCTFail("Expected 1 edit")
            return
        }

        let edit = result[0]
        XCTAssertEqual(edit.text, kGeneratedFDoc)
    }

    func testAt_0_5() throws {
        let fResult = functionF.formatAt(start: 0, end: 5)
        guard fResult.count == 1 else {
            XCTFail("Expected 1 edit")
            return
        }

        XCTAssertEqual(fResult[0].text, kGeneratedFDoc)

        let gResult = functionG.formatAt(start: 0, end: 5)
        guard gResult.count == 1 else {
            XCTFail("Expected 1 edit")
            return
        }

        XCTAssertEqual(gResult[0].text, kGeneratedGDoc)
    }

    func testAt_0_6() throws {
        let fResult = functionF.formatAt(start: 0, end: 6)
        guard fResult.count == 1 else {
            XCTFail("Expected 1 edit")
            return
        }

        XCTAssertEqual(fResult[0].text, kGeneratedFDoc)

        let gResult = functionG.formatAt(start: 0, end: 6)
        guard gResult.count == 1 else {
            XCTFail("Expected 1 edit")
            return
        }

        XCTAssertEqual(gResult[0].text, kGeneratedGDoc)
    }

    func testAt_0_8() throws {
        let fResult = functionF.formatAt(start: 0, end: 8)
        guard fResult.count == 1 else {
            XCTFail("Expected 1 edit")
            return
        }

        XCTAssertEqual(fResult[0].text, kGeneratedFDoc)

        let gResult = functionG.formatAt(start: 0, end: 8)
        guard gResult.count == 1 else {
            XCTFail("Expected 1 edit")
            return
        }

        XCTAssertEqual(gResult[0].text, kGeneratedGDoc)
    }

    func testAt_5_8() throws {
        let fResult = functionF.formatAt(start: 5, end: 8)
        XCTAssert(fResult.isEmpty)

        let gResult = functionG.formatAt(start: 5, end: 8)
        guard gResult.count == 1 else {
            XCTFail("Expected 1 edit")
            return
        }

        XCTAssertEqual(gResult[0].text, kGeneratedGDoc)
    }

    func testAt_8_8() throws {
        let fResult = functionF.formatAt(start: 8, end: 8)
        XCTAssert(fResult.isEmpty)

        let gResult = functionG.formatAt(start: 8, end: 8)
        guard gResult.count == 1 else {
            XCTFail("Expected 1 edit")
            return
        }

        XCTAssertEqual(gResult[0].text, kGeneratedGDoc)
    }

    func testAt_4_4() throws {
        let fResult = functionF.formatAt(start: 4, end: 4)
        XCTAssert(fResult.isEmpty)

        let gResult = functionG.formatAt(start: 4, end: 4)
        XCTAssert(gResult.isEmpty)
    }
}
