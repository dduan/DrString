@testable import DrDecipher
import XCTest

final class LineParsingTests: XCTestCase {
    private func equal<T0: Equatable, T1: Equatable>(_ result: (T0, T1)?, _ expectation: (T0, T1)) -> Bool {
        if result?.0 == expectation.0 && result?.1 == expectation.1 {
            return true
        }

        print(String(describing: result), expectation)
        return false
    }

    func testWords0() throws {
        XCTAssertEqual(try parseWords(fromLine: "///"), TextLeadByWhitespace("", ""))
    }

    func testWords1() throws {
        XCTAssertEqual(try parseWords(fromLine: " ///"), TextLeadByWhitespace("", ""))
    }

    func testWords2() throws {
        XCTAssertEqual(try parseWords(fromLine: " /// "), TextLeadByWhitespace(" ", ""))
    }

    func testWords3() throws {
        XCTAssertEqual(try parseWords(fromLine: "///  some stuff"), TextLeadByWhitespace("  ", "some stuff"))
    }

    func testWords4() throws {
        XCTAssertEqual(try parseWords(fromLine: "  /// some stuff"), TextLeadByWhitespace(" ", "some stuff"))
    }

    func testGroupedParameterHeader0() throws {
        XCTAssert(equal(
            try parseGroupedParametersHeader(fromLine: "/// - Parameters"),
            (" ", TextLeadByWhitespace(" ", "Parameters"))
        ))
    }
    
    func testGroupedParameterHeader1() throws {
        XCTAssert(equal(
            try parseGroupedParametersHeader(fromLine: "/// - parameters"),
            (" ", TextLeadByWhitespace(" ", "parameters"))
        ))
    }
    
    func testGroupedParameterHeader2() throws {
        XCTAssert(equal(
            try parseGroupedParametersHeader(fromLine: "///-Parameters"),
            ("", TextLeadByWhitespace("", "Parameters"))
        ))
    }
    
    func testGroupedParameterHeader3() throws {
        XCTAssert(equal(
            try parseGroupedParametersHeader(fromLine: "///-parameters"),
            ("", TextLeadByWhitespace("", "parameters"))
        ))
    }
    
    func testGroupedParameterHeader4() throws {
        XCTAssert(equal(
            try parseGroupedParametersHeader(fromLine: "///- Parameters"),
            ("", TextLeadByWhitespace(" ", "Parameters"))
        ))
    }
    
    func testGroupedParameterHeader5() throws {
        XCTAssert(equal(
            try parseGroupedParametersHeader(fromLine: "/// -Parameters"),
            (" ", TextLeadByWhitespace("", "Parameters"))
        ))
    }
    
    func testGroupedParameterHeader6() throws {
        XCTAssert(equal(
            try parseGroupedParametersHeader(fromLine: "///   -   Parameters"),
            ("   ", TextLeadByWhitespace("   ", "Parameters"))
        ))
    }
    
    func testGroupedParameterHeader7() throws {
        XCTAssert(equal(
            try parseGroupedParametersHeader(fromLine: "/// - Parameters "),
            (" ", TextLeadByWhitespace(" ", "Parameters "))
        ))
    }
    
    func testGroupedParameterHeader8() throws {
        XCTAssert(equal(
            try parseGroupedParametersHeader(fromLine: "/// - Parametersss"),
            (" ", TextLeadByWhitespace(" ", "Parametersss"))
        ))
    }
    
    func testGroupedParameterHeader9() throws {
        XCTAssertNil(try parseGroupedParametersHeader(fromLine: "/// Parametersss"))
    }
    
    func testGroupedParameterHeader10() throws {
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
