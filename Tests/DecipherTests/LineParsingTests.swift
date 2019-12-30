@testable import Decipher
import XCTest

final class LineParsingTests: XCTestCase {
    func testWords0() throws {
        XCTAssertEqual(try parseWords(fromLine: "///"), .empty)
    }

    func testWords1() throws {
        XCTAssertEqual(try parseWords(fromLine: " ///"), .empty)
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
        let (preDash, param, preColon, hasColon, postColon) = try XCTUnwrap(parseGroupedParametersHeader(fromLine: "/// - Parameters:"))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(param, TextLeadByWhitespace(" ", "Parameters"))
        XCTAssertEqual(preColon, "")
        XCTAssert(hasColon)
        XCTAssertEqual(postColon, TextLeadByWhitespace("", ""))
    }

    func testGroupedParameterHeader1() throws {
        let (preDash, param, preColon, hasColon, postColon) = try XCTUnwrap(parseGroupedParametersHeader(fromLine: "/// - parameters:"))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(param, TextLeadByWhitespace(" ", "parameters"))
        XCTAssertEqual(preColon, "")
        XCTAssert(hasColon)
        XCTAssertEqual(postColon, TextLeadByWhitespace("", ""))
    }

    func testGroupedParameterHeader2() throws {
        let (preDash, param, preColon, hasColon, postColon) = try XCTUnwrap(parseGroupedParametersHeader(fromLine: "///-Parameters:"))
        XCTAssertEqual(preDash, "")
        XCTAssertEqual(param, TextLeadByWhitespace("", "Parameters"))
        XCTAssertEqual(preColon, "")
        XCTAssert(hasColon)
        XCTAssertEqual(postColon, TextLeadByWhitespace("", ""))
    }

    func testGroupedParameterHeader3() throws {
        let (preDash, param, preColon, hasColon, postColon) = try XCTUnwrap(parseGroupedParametersHeader(fromLine: "///-parameters:"))
        XCTAssertEqual(preDash, "")
        XCTAssertEqual(param, TextLeadByWhitespace("", "parameters"))
        XCTAssertEqual(preColon, "")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(postColon, TextLeadByWhitespace("", ""))
    }

    func testGroupedParameterHeader4() throws {
        let (preDash, param, preColon, hasColon, postColon) = try XCTUnwrap(parseGroupedParametersHeader(fromLine: "///- Parameters:"))
        XCTAssertEqual(preDash, "")
        XCTAssertEqual(param, TextLeadByWhitespace(" ", "Parameters"))
        XCTAssertEqual(preColon, "")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(postColon, TextLeadByWhitespace("", ""))
    }

    func testGroupedParameterHeader5() throws {
        let (preDash, param, preColon, hasColon, postColon) = try XCTUnwrap(parseGroupedParametersHeader(fromLine: "/// -Parameters:"))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(param, TextLeadByWhitespace("", "Parameters"))
        XCTAssertEqual(preColon, "")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(postColon, TextLeadByWhitespace("", ""))
    }

    func testGroupedParameterHeader6() throws {
        let (preDash, param, preColon, hasColon, postColon) = try XCTUnwrap(parseGroupedParametersHeader(fromLine: "///   -   Parameters:"))
        XCTAssertEqual(preDash, "   ")
        XCTAssertEqual(param, TextLeadByWhitespace("   ", "Parameters"))
        XCTAssertEqual(preColon, "")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(postColon, TextLeadByWhitespace("", ""))
    }

    func testGroupedParameterHeader7() throws {
        let (preDash, param, preColon, hasColon, postColon) = try XCTUnwrap(parseGroupedParametersHeader(fromLine: "/// - Parameters: "))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(param, TextLeadByWhitespace(" ", "Parameters"))
        XCTAssertEqual(preColon, "")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(postColon, TextLeadByWhitespace(" ", ""))
    }

    func testGroupedParameterHeader8() throws {
        let (preDash, param, preColon, hasColon, postColon) = try XCTUnwrap(parseGroupedParametersHeader(fromLine: "/// - Parametersss:"))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(param, TextLeadByWhitespace(" ", "Parametersss"))
        XCTAssertEqual(preColon, "")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(postColon, TextLeadByWhitespace("", ""))
    }

    func testGroupedParameterHeader9() throws {
        let (preDash, param, preColon, hasColon, postColon) = try XCTUnwrap(parseGroupedParametersHeader(fromLine: "/// - Parametersss:    "))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(param, TextLeadByWhitespace(" ", "Parametersss"))
        XCTAssertEqual(preColon, "")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(postColon, TextLeadByWhitespace("    ", ""))
    }

    func testGroupedParameterHeader10() throws {
        let (preDash, param, preColon, hasColon, postColon) = try XCTUnwrap(parseGroupedParametersHeader(fromLine: "/// - Parametersss:    sss"))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(param, TextLeadByWhitespace(" ", "Parametersss"))
        XCTAssertEqual(preColon, "")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(postColon, TextLeadByWhitespace("    ", "sss"))
    }

    func testGroupedParameterHeader11() throws {
        XCTAssertNil(try parseGroupedParametersHeader(fromLine: "/// Parametersss"))
    }

    func testGroupedParameterHeader12() throws {
        XCTAssertNil(try parseGroupedParametersHeader(fromLine: "/// - xParametersss"))
    }

    func testGroupedParameterHeader13() throws {
        let (preDash, param, preColon, hasColon, postColon) = try XCTUnwrap(parseGroupedParametersHeader(fromLine: "/// - Parameters   :"))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(param, TextLeadByWhitespace(" ", "Parameters"))
        XCTAssertEqual(preColon, "   ")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(postColon, TextLeadByWhitespace("", ""))
    }

    func testGroupedParameter0() throws {
        let (preDash, name, preColon, hasColon, desc) = try XCTUnwrap(parseGroupedParameter(fromLine: "/// - name: description"))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(name, TextLeadByWhitespace(" ", "name"))
        XCTAssertEqual(preColon, "")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(desc, TextLeadByWhitespace(" ", "description"))

    }

    func testGroupedParameter1() throws {
        let (preDash, name, preColon, hasColon, desc) = try XCTUnwrap(parseGroupedParameter(fromLine: "///-name:description"))
        XCTAssertEqual(preDash, "")
        XCTAssertEqual(name, TextLeadByWhitespace("", "name"))
        XCTAssertEqual(preColon, "")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(desc, TextLeadByWhitespace("", "description"))
    }

    func testGroupedParameter2() throws {
        let (preDash, name, preColon, hasColon, desc) = try XCTUnwrap(parseGroupedParameter(fromLine: "///-name:   \tdescription w"))
        XCTAssertEqual(preDash, "")
        XCTAssertEqual(name, TextLeadByWhitespace("", "name"))
        XCTAssertEqual(preColon, "")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(desc, TextLeadByWhitespace("   \t", "description w"))
    }

    func testGroupedParameter3() throws {
        let (preDash, name, preColon, hasColon, desc) = try XCTUnwrap(parseGroupedParameter(fromLine: "///   -\tname:   description "))
        XCTAssertEqual(preDash, "   ")
        XCTAssertEqual(name, TextLeadByWhitespace("\t", "name"))
        XCTAssertEqual(preColon, "")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(desc, TextLeadByWhitespace("   ", "description "))
    }

    func testGroupedParameter4() throws {
        let (preDash, name, preColon, hasColon, desc) = try XCTUnwrap(parseGroupedParameter(fromLine: "/// - name: description "))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(name, TextLeadByWhitespace(" ", "name"))
        XCTAssertEqual(preColon, "")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(desc, TextLeadByWhitespace(" ", "description "))
    }

    func testGroupedParameter5() throws {
        let (preDash, name, preColon, hasColon, desc) = try XCTUnwrap(parseGroupedParameter(fromLine: "/// - name :"))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(name, TextLeadByWhitespace(" ", "name"))
        XCTAssertEqual(preColon, " ")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(desc, TextLeadByWhitespace("", ""))
    }

    func testGroupedParameter6() throws {
        let (preDash, name, preColon, hasColon, desc) = try XCTUnwrap(parseGroupedParameter(fromLine: "/// - name :  "))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(name, TextLeadByWhitespace(" ", "name"))
        XCTAssertEqual(preColon, " ")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(desc, TextLeadByWhitespace("  ", ""))
    }

    func testGroupedParameter7() throws {
        let (preDash, name, preColon, hasColon, desc) = try XCTUnwrap(parseGroupedParameter(fromLine: "/// - name :\t"))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(name, TextLeadByWhitespace(" ", "name"))
        XCTAssertEqual(preColon, " ")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(desc, TextLeadByWhitespace("\t", ""))
    }

    func testGroupedParameterMissingColon0() throws {
        let (preDash, name, preColon, hasColon, desc) = try XCTUnwrap(parseGroupedParameter(fromLine: "/// - name description"))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(name, TextLeadByWhitespace(" ", "name"))
        XCTAssertEqual(preColon, "")
        XCTAssertFalse(hasColon)
        XCTAssertEqual(desc, TextLeadByWhitespace(" ", "description"))

    }

    func testParameter0() throws {
        let (preDash, param, name, preColon, hasColon, desc) = try XCTUnwrap(parseParameter(fromLine: "/// - Parameter name: description"))

        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(param, TextLeadByWhitespace(" ", "Parameter"))
        XCTAssertEqual(name, TextLeadByWhitespace(" ", "name"))
        XCTAssertEqual(preColon, "")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(desc, TextLeadByWhitespace(" ", "description"))
    }

    func testParameter1() throws {
        let (preDash, param, name, preColon, hasColon, desc) = try XCTUnwrap(parseParameter(fromLine: "/// - parameter name: description  "))

        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(param, TextLeadByWhitespace(" ", "parameter"))
        XCTAssertEqual(name, TextLeadByWhitespace(" ", "name"))
        XCTAssertEqual(preColon, "")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(desc, TextLeadByWhitespace(" ", "description  "))
    }

    func testParameter2() throws {
        let (preDash, param, name, preColon, hasColon, desc) = try XCTUnwrap(parseParameter(fromLine: "///-parameter name :description"))

        XCTAssertEqual(preDash, "")
        XCTAssertEqual(param, TextLeadByWhitespace("", "parameter"))
        XCTAssertEqual(name, TextLeadByWhitespace(" ", "name"))
        XCTAssertEqual(preColon, " ")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(desc, TextLeadByWhitespace("", "description"))
    }

    func testParameter3() throws {
        let (preDash, param, name, preColon, hasColon, desc) = try XCTUnwrap(parseParameter(fromLine: "///-  Parameter name:   \tdescription"))

        XCTAssertEqual(preDash, "")
        XCTAssertEqual(param, TextLeadByWhitespace("  ", "Parameter"))
        XCTAssertEqual(name, TextLeadByWhitespace(" ", "name"))
        XCTAssertEqual(preColon, "")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(desc, TextLeadByWhitespace("   \t", "description"))
    }

    func testParameter4() throws {
        let (preDash, param, name, preColon, hasColon, desc) = try XCTUnwrap(parseParameter(fromLine: "///   - parameter \tname  :   description "))

        XCTAssertEqual(preDash, "   ")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(param, TextLeadByWhitespace(" ", "parameter"))
        XCTAssertEqual(name, TextLeadByWhitespace(" \t", "name"))
        XCTAssertEqual(preColon, "  ")
        XCTAssertEqual(desc, TextLeadByWhitespace("   ", "description "))
    }

    func testParameterMissingColon0() throws {
        let (preDash, param, name, preColon, hasColon, desc) = try XCTUnwrap(parseParameter(fromLine: "/// - Parameter name description"))

        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(param, TextLeadByWhitespace(" ", "Parameter"))
        XCTAssertEqual(name, TextLeadByWhitespace(" ", "name"))
        XCTAssertEqual(preColon, "")
        XCTAssertFalse(hasColon)
        XCTAssertEqual(desc, TextLeadByWhitespace(" ", "description"))
    }

    func testReturns0() throws {
        let (preDash, keyword, preColon, hasColon, desc) = try XCTUnwrap(parseReturns(fromLine: "/// - Returns: description"))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(keyword, TextLeadByWhitespace(" ", "Returns"))
        XCTAssertEqual(preColon, "")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(desc, TextLeadByWhitespace(" ", "description"))
    }

    func testReturns1() throws {
        let (preDash, keyword, preColon, hasColon, desc) = try XCTUnwrap(parseReturns(fromLine: "/// - returns: description"))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(keyword, TextLeadByWhitespace(" ", "returns"))
        XCTAssertEqual(preColon, "")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(desc, TextLeadByWhitespace(" ", "description"))
    }

    func testReturns2() throws {
        let (preDash, keyword, preColon, hasColon, desc) = try XCTUnwrap(parseReturns(fromLine: "/// - Return : description"))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(keyword, TextLeadByWhitespace(" ", "Return"))
        XCTAssertEqual(preColon, " ")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(desc, TextLeadByWhitespace(" ", "description"))
    }

    func testReturns3() throws {
        let (preDash, keyword, preColon, hasColon, desc) = try XCTUnwrap(parseReturns(fromLine: "///- return: description"))
        XCTAssertEqual(preDash, "")
        XCTAssertEqual(keyword, TextLeadByWhitespace(" ", "return"))
        XCTAssertEqual(preColon, "")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(desc, TextLeadByWhitespace(" ", "description"))
    }

    func testReturns4() throws {
        let (preDash, keyword, preColon, hasColon, desc) = try XCTUnwrap(parseReturns(fromLine: "/// - Returnnyah: description "))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(keyword, TextLeadByWhitespace(" ", "Returnnyah"))
        XCTAssertEqual(preColon, "")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(desc, TextLeadByWhitespace(" ", "description "))
    }

    func testReturns5() throws {
        let (preDash, keyword, preColon, hasColon, desc) = try XCTUnwrap(parseReturns(fromLine: "///-Returns :description"))
        XCTAssertEqual(preDash, "")
        XCTAssertEqual(keyword, TextLeadByWhitespace("", "Returns"))
        XCTAssertEqual(preColon, " ")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(desc, TextLeadByWhitespace("", "description"))
    }

    func testReturnsMissingColon0() throws {
        let (preDash, keyword, preColon, hasColon, desc) = try XCTUnwrap(parseReturns(fromLine: "/// - Returns description"))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(keyword, TextLeadByWhitespace(" ", "Returns"))
        XCTAssertEqual(preColon, "")
        XCTAssertFalse(hasColon)
        XCTAssertEqual(desc, TextLeadByWhitespace(" ", "description"))
    }

    func testThrows0() throws {
        let (preDash, keyword, preColon, hasColon, desc) = try XCTUnwrap(parseThrows(fromLine: "/// - Throws: description"))
        XCTAssertEqual(preDash,  " ")
        XCTAssertEqual(keyword, TextLeadByWhitespace(" ", "Throws"))
        XCTAssertEqual(preColon, "")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(desc, TextLeadByWhitespace(" ", "description"))
    }

    func testThrows1() throws {
        let (preDash, keyword, preColon, hasColon, desc) = try XCTUnwrap(parseThrows(fromLine: "/// - throws: description"))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(keyword, TextLeadByWhitespace(" ", "throws"))
        XCTAssertEqual(preColon, "")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(desc, TextLeadByWhitespace(" ", "description"))
    }

    func testThrows2() throws {
        let (preDash, keyword, preColon, hasColon, desc) = try XCTUnwrap(parseThrows(fromLine: "/// - Throw: description"))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(keyword, TextLeadByWhitespace(" ", "Throw"))
        XCTAssertEqual(preColon, "")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(desc, TextLeadByWhitespace(" ", "description"))
    }

    func testThrows3() throws {
        let (preDash, keyword, preColon, hasColon, desc) = try XCTUnwrap(parseThrows(fromLine: "/// - throw: description"))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(keyword, TextLeadByWhitespace(" ", "throw"))
        XCTAssertEqual(preColon, "")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(desc, TextLeadByWhitespace(" ", "description"))
    }

    func testThrows4() throws {
        let (preDash, keyword, preColon, hasColon, desc) = try XCTUnwrap(parseThrows(fromLine: "/// -  Thrownyah: description "))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(keyword, TextLeadByWhitespace("  ", "Thrownyah"))
        XCTAssertEqual(preColon, "")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(desc, TextLeadByWhitespace(" ", "description "))
    }

    func testThrows5() throws {
        let (preDash, keyword, preColon, hasColon, desc) = try XCTUnwrap(parseThrows(fromLine: "///-Throws :description"))
        XCTAssertEqual(preDash, "")
        XCTAssertEqual(keyword, TextLeadByWhitespace("", "Throws"))
        XCTAssertEqual(preColon, " ")
        XCTAssertTrue(hasColon)
        XCTAssertEqual(desc, TextLeadByWhitespace("", "description"))
    }

    func testThrowsMissingColon0() throws {
        let (preDash, keyword, preColon, hasColon, desc) = try XCTUnwrap(parseThrows(fromLine: "/// - Throws description"))
        XCTAssertEqual(preDash,  " ")
        XCTAssertEqual(keyword, TextLeadByWhitespace(" ", "Throws"))
        XCTAssertEqual(preColon, "")
        XCTAssertFalse(hasColon)
        XCTAssertEqual(desc, TextLeadByWhitespace(" ", "description"))
    }
}
