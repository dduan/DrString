#if !canImport(ObjectiveC)
import XCTest

extension LineParsingTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__LineParsingTests = [
        ("testGroupedParameter0", testGroupedParameter0),
        ("testGroupedParameter1", testGroupedParameter1),
        ("testGroupedParameter2", testGroupedParameter2),
        ("testGroupedParameter3", testGroupedParameter3),
        ("testGroupedParameter4", testGroupedParameter4),
        ("testGroupedParameter5", testGroupedParameter5),
        ("testGroupedParameter6", testGroupedParameter6),
        ("testGroupedParameter7", testGroupedParameter7),
        ("testGroupedParameterHeader0", testGroupedParameterHeader0),
        ("testGroupedParameterHeader10", testGroupedParameterHeader10),
        ("testGroupedParameterHeader11", testGroupedParameterHeader11),
        ("testGroupedParameterHeader12", testGroupedParameterHeader12),
        ("testGroupedParameterHeader13", testGroupedParameterHeader13),
        ("testGroupedParameterHeader1", testGroupedParameterHeader1),
        ("testGroupedParameterHeader2", testGroupedParameterHeader2),
        ("testGroupedParameterHeader3", testGroupedParameterHeader3),
        ("testGroupedParameterHeader4", testGroupedParameterHeader4),
        ("testGroupedParameterHeader5", testGroupedParameterHeader5),
        ("testGroupedParameterHeader6", testGroupedParameterHeader6),
        ("testGroupedParameterHeader7", testGroupedParameterHeader7),
        ("testGroupedParameterHeader8", testGroupedParameterHeader8),
        ("testGroupedParameterHeader9", testGroupedParameterHeader9),
        ("testParameter0", testParameter0),
        ("testParameter1", testParameter1),
        ("testParameter2", testParameter2),
        ("testParameter3", testParameter3),
        ("testParameter4", testParameter4),
        ("testReturns0", testReturns0),
        ("testReturns1", testReturns1),
        ("testReturns2", testReturns2),
        ("testReturns3", testReturns3),
        ("testReturns4", testReturns4),
        ("testReturns5", testReturns5),
        ("testThrows0", testThrows0),
        ("testThrows1", testThrows1),
        ("testThrows2", testThrows2),
        ("testThrows3", testThrows3),
        ("testThrows4", testThrows4),
        ("testThrows5", testThrows5),
        ("testWords0", testWords0),
        ("testWords1", testWords1),
        ("testWords2", testWords2),
        ("testWords3", testWords3),
        ("testWords4", testWords4),
    ]
}

extension StatefulParsingTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__StatefulParsingTests = [
        ("testNormalGroupedParameterState", testNormalGroupedParameterState),
        ("testNormalSeparateParameterState", testNormalSeparateParameterState),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(LineParsingTests.__allTests__LineParsingTests),
        testCase(StatefulParsingTests.__allTests__StatefulParsingTests),
    ]
}
#endif
