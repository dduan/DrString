@testable import DrDecipher
import XCTest

final class LineParsingTests: XCTestCase {
    private func equal(_ result: (String, String)?, _ expectation: (String, String)) -> Bool {
        return result?.0 == expectation.0 && result?.1 == expectation.1
    }

    func testWords() throws {
        XCTAssert(equal(try parseWords(fromLine: "///"), ("", "")))
        XCTAssert(equal(try parseWords(fromLine: " ///"), ("", "")))
        XCTAssert(equal(try parseWords(fromLine: " /// "), (" ", "")))
        XCTAssert(equal(try parseWords(fromLine: "///  some stuff"), ("  ", "some stuff")))
        XCTAssert(equal(try parseWords(fromLine: "  /// some stuff"), (" ", "some stuff")))
    }

    func testGroupedParameterHeader() throws {
        XCTAssertEqual(try parseGroupedParametersHeader(fromLine: "/// - Parameters"), "- Parameters")
        XCTAssertEqual(try parseGroupedParametersHeader(fromLine: "/// - parameters"), "- parameters")
        XCTAssertEqual(try parseGroupedParametersHeader(fromLine: "///-Parameters"), "-Parameters")
        XCTAssertEqual(try parseGroupedParametersHeader(fromLine: "///-parameters"), "-parameters")
        XCTAssertEqual(try parseGroupedParametersHeader(fromLine: "///- Parameters"), "- Parameters")
        XCTAssertEqual(try parseGroupedParametersHeader(fromLine: "/// -Parameters"), "-Parameters")
        XCTAssertEqual(try parseGroupedParametersHeader(fromLine: "///   -   Parameters"), "-   Parameters")
        XCTAssertEqual(try parseGroupedParametersHeader(fromLine: "/// - Parameters "),"- Parameters ")
        XCTAssertEqual(try parseGroupedParametersHeader(fromLine: "/// - Parametersss"), "- Parametersss")
        XCTAssertNil(try parseGroupedParametersHeader(fromLine: "/// Parametersss"))
        XCTAssertNil(try parseGroupedParametersHeader(fromLine: "/// - xParametersss"))
    }

    func testGroupedParameter() throws {
        let expected0 = ("name", "description")
        XCTAssert(equal(try parseGroupedParameter(fromLine: "/// - name: description"), expected0))
        XCTAssert(equal(try parseGroupedParameter(fromLine: "///-name:description"), expected0))
        XCTAssert(equal(try parseGroupedParameter(fromLine: "///-name:   \tdescription"), expected0))
        XCTAssert(equal(try parseGroupedParameter(fromLine: "///   -\tname:   description"), expected0))

        let expected1 = ("name", "description ")
        XCTAssert(equal(try parseGroupedParameter(fromLine: "/// - name: description "), expected1))

        let expected2 = ("name", "")
        XCTAssert(equal(try parseGroupedParameter(fromLine: "/// - name:"), expected2))
        XCTAssert(equal(try parseGroupedParameter(fromLine: "/// - name:  "), expected2))
        XCTAssert(equal(try parseGroupedParameter(fromLine: "/// - name:\t"), expected2))
    }

    func testParameter() throws {
        let expected0 = ("name", "description")
        XCTAssert(equal(try parseParameter(fromLine: "/// - Parameter name: description"), expected0))
        XCTAssert(equal(try parseParameter(fromLine: "/// - parameter name: description"), expected0))
        XCTAssert(equal(try parseParameter(fromLine: "///-parameter name:description"), expected0))
        XCTAssert(equal(try parseParameter(fromLine: "///-  Parameter name:   \tdescription"), expected0))
        XCTAssert(equal(try parseParameter(fromLine: "///   - parameter \tname:   description"), expected0))
    }

    func testReturns() throws {
        XCTAssertEqual(try parseReturns(fromLine: "/// - Returns: description"), "description")
        XCTAssertEqual(try parseReturns(fromLine: "/// - returns: description"), "description")
        XCTAssertEqual(try parseReturns(fromLine: "/// - Return: description"), "description")
        XCTAssertEqual(try parseReturns(fromLine: "/// - return: description"), "description")
        XCTAssertEqual(try parseReturns(fromLine: "/// - Returnnyah: description"), "description")
        XCTAssertEqual(try parseReturns(fromLine: "///-Returns :description"), "description")
    }

    func testThrows() throws {
        XCTAssertEqual(try parseThrows(fromLine: "/// - Throws: description"), "description")
        XCTAssertEqual(try parseThrows(fromLine: "/// - throws: description"), "description")
        XCTAssertEqual(try parseThrows(fromLine: "/// - Throw: description"), "description")
        XCTAssertEqual(try parseThrows(fromLine: "/// - throw: description"), "description")
        XCTAssertEqual(try parseThrows(fromLine: "/// - Thrownyah: description"), "description")
        XCTAssertEqual(try parseThrows(fromLine: "///-Throws :description"), "description")
    }

    func testIndentation() throws {
        XCTAssertEqual(try parseIndentation(fromLine: "/// description"), "")
        XCTAssertEqual(try parseIndentation(fromLine: "    /// description"), "    ")
        XCTAssertEqual(try parseIndentation(fromLine: "\t/// description"), "\t")
        XCTAssertEqual(try parseIndentation(fromLine: "\t /// description"), "\t ")
    }
}
