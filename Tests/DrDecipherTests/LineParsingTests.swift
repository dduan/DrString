@testable import DrDecipher
import XCTest

final class LineParsingTests: XCTestCase {
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
        let (preDash, param) = try XCTUnwrap(parseGroupedParametersHeader(fromLine: "/// - Parameters"))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(param, TextLeadByWhitespace(" ", "Parameters"))
    }
    
    func testGroupedParameterHeader1() throws {
        let (preDash, param) = try XCTUnwrap(parseGroupedParametersHeader(fromLine: "/// - parameters"))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(param, TextLeadByWhitespace(" ", "parameters"))
    }
    
    func testGroupedParameterHeader2() throws {
        let (preDash, param) = try XCTUnwrap(parseGroupedParametersHeader(fromLine: "///-Parameters"))
        XCTAssertEqual(preDash, "")
        XCTAssertEqual(param, TextLeadByWhitespace("", "Parameters"))
    }
    
    func testGroupedParameterHeader3() throws {
        let (preDash, param) = try XCTUnwrap(parseGroupedParametersHeader(fromLine: "///-parameters"))
        XCTAssertEqual(preDash, "")
        XCTAssertEqual(param, TextLeadByWhitespace("", "parameters"))
    }
    
    func testGroupedParameterHeader4() throws {
        let (preDash, param) = try XCTUnwrap(parseGroupedParametersHeader(fromLine: "///- Parameters"))
        XCTAssertEqual(preDash, "")
        XCTAssertEqual(param, TextLeadByWhitespace(" ", "Parameters"))
    }
    
    func testGroupedParameterHeader5() throws {
        let (preDash, param) = try XCTUnwrap(parseGroupedParametersHeader(fromLine: "/// -Parameters"))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(param, TextLeadByWhitespace("", "Parameters"))
    }
    
    func testGroupedParameterHeader6() throws {
        let (preDash, param) = try XCTUnwrap(parseGroupedParametersHeader(fromLine: "///   -   Parameters"))
        XCTAssertEqual(preDash, "   ")
        XCTAssertEqual(param, TextLeadByWhitespace("   ", "Parameters"))
    }
    
    func testGroupedParameterHeader7() throws {
        let (preDash, param) = try XCTUnwrap(parseGroupedParametersHeader(fromLine: "/// - Parameters "))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(param, TextLeadByWhitespace(" ", "Parameters "))
    }
    
    func testGroupedParameterHeader8() throws {
        let (preDash, param) = try XCTUnwrap(parseGroupedParametersHeader(fromLine: "/// - Parametersss"))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(param, TextLeadByWhitespace(" ", "Parametersss"))
    }
    
    func testGroupedParameterHeader9() throws {
        XCTAssertNil(try parseGroupedParametersHeader(fromLine: "/// Parametersss"))
    }
    
    func testGroupedParameterHeader10() throws {
        XCTAssertNil(try parseGroupedParametersHeader(fromLine: "/// - xParametersss"))
    }

    func testGroupedParameter0() throws {
        let (preDash, name, preColon, desc) = try XCTUnwrap(parseGroupedParameter(fromLine: "/// - name: description"))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(name, TextLeadByWhitespace(" ", "name"))
        XCTAssertEqual(preColon, "")
        XCTAssertEqual(desc, TextLeadByWhitespace(" ", "description"))

    }

    func testGroupedParameter1() throws {
        let (preDash, name, preColon, desc) = try XCTUnwrap(parseGroupedParameter(fromLine: "///-name:description"))
        XCTAssertEqual(preDash, "")
        XCTAssertEqual(name, TextLeadByWhitespace("", "name"))
        XCTAssertEqual(preColon, "")
        XCTAssertEqual(desc, TextLeadByWhitespace("", "description"))
    }

    func testGroupedParameter2() throws {
        let (preDash, name, preColon, desc) = try XCTUnwrap(parseGroupedParameter(fromLine: "///-name:   \tdescription w"))
        XCTAssertEqual(preDash, "")
        XCTAssertEqual(name, TextLeadByWhitespace("", "name"))
        XCTAssertEqual(preColon, "")
        XCTAssertEqual(desc, TextLeadByWhitespace("   \t", "description w"))
    }

    func testGroupedParameter3() throws {
        let (preDash, name, preColon, desc) = try XCTUnwrap(parseGroupedParameter(fromLine: "///   -\tname:   description "))
        XCTAssertEqual(preDash, "   ")
        XCTAssertEqual(name, TextLeadByWhitespace("\t", "name"))
        XCTAssertEqual(preColon, "")
        XCTAssertEqual(desc, TextLeadByWhitespace("   ", "description "))
    }

    func testGroupedParameter4() throws {
        let (preDash, name, preColon, desc) = try XCTUnwrap(parseGroupedParameter(fromLine: "/// - name: description "))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(name, TextLeadByWhitespace(" ", "name"))
        XCTAssertEqual(preColon, "")
        XCTAssertEqual(desc, TextLeadByWhitespace(" ", "description "))
    }

    func testGroupedParameter5() throws {
        let (preDash, name, preColon, desc) = try XCTUnwrap(parseGroupedParameter(fromLine: "/// - name :"))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(name, TextLeadByWhitespace(" ", "name"))
        XCTAssertEqual(preColon, " ")
        XCTAssertEqual(desc, TextLeadByWhitespace("", ""))
    }

    func testGroupedParameter6() throws {
        let (preDash, name, preColon, desc) = try XCTUnwrap(parseGroupedParameter(fromLine: "/// - name :  "))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(name, TextLeadByWhitespace(" ", "name"))
        XCTAssertEqual(preColon, " ")
        XCTAssertEqual(desc, TextLeadByWhitespace("  ", ""))
    }

    func testGroupedParameter7() throws {
        let (preDash, name, preColon, desc) = try XCTUnwrap(parseGroupedParameter(fromLine: "/// - name :\t"))
        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(name, TextLeadByWhitespace(" ", "name"))
        XCTAssertEqual(preColon, " ")
        XCTAssertEqual(desc, TextLeadByWhitespace("\t", ""))
    }

    func testParameter0() throws {
        let (preDash, param, name, preColon, desc) = try XCTUnwrap(parseParameter(fromLine: "/// - Parameter name: description"))

        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(param, TextLeadByWhitespace(" ", "Parameter"))
        XCTAssertEqual(name, TextLeadByWhitespace(" ", "name"))
        XCTAssertEqual(preColon, "")
        XCTAssertEqual(desc, TextLeadByWhitespace(" ", "description"))
    }

    func testParameter1() throws {
        let (preDash, param, name, preColon, desc) = try XCTUnwrap(parseParameter(fromLine: "/// - parameter name: description  "))

        XCTAssertEqual(preDash, " ")
        XCTAssertEqual(param, TextLeadByWhitespace(" ", "parameter"))
        XCTAssertEqual(name, TextLeadByWhitespace(" ", "name"))
        XCTAssertEqual(preColon, "")
        XCTAssertEqual(desc, TextLeadByWhitespace(" ", "description  "))
    }

    func testParameter2() throws {
        let (preDash, param, name, preColon, desc) = try XCTUnwrap(parseParameter(fromLine: "///-parameter name :description"))

        XCTAssertEqual(preDash, "")
        XCTAssertEqual(param, TextLeadByWhitespace("", "parameter"))
        XCTAssertEqual(name, TextLeadByWhitespace(" ", "name"))
        XCTAssertEqual(preColon, " ")
        XCTAssertEqual(desc, TextLeadByWhitespace("", "description"))
    }

    func testParameter3() throws {
        let (preDash, param, name, preColon, desc) = try XCTUnwrap(parseParameter(fromLine: "///-  Parameter name:   \tdescription"))

        XCTAssertEqual(preDash, "")
        XCTAssertEqual(param, TextLeadByWhitespace("  ", "Parameter"))
        XCTAssertEqual(name, TextLeadByWhitespace(" ", "name"))
        XCTAssertEqual(preColon, "")
        XCTAssertEqual(desc, TextLeadByWhitespace("   \t", "description"))
    }

    func testParameter4() throws {
        let (preDash, param, name, preColon, desc) = try XCTUnwrap(parseParameter(fromLine: "///   - parameter \tname  :   description "))

        XCTAssertEqual(preDash, "   ")
        XCTAssertEqual(param, TextLeadByWhitespace(" ", "parameter"))
        XCTAssertEqual(name, TextLeadByWhitespace(" \t", "name"))
        XCTAssertEqual(preColon, "  ")
        XCTAssertEqual(desc, TextLeadByWhitespace("   ", "description "))
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
