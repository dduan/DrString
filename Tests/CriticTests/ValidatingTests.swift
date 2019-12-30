@testable import Critic
@testable import Crawler
@testable import Decipher
import XCTest

private let kParamA = Parameter(label: nil, name: "a", type: "A", isVariadic: false, hasDefault: false)
private let kParamB = Parameter(label: nil, name: "b", type: "B", isVariadic: false, hasDefault: false)
private let kParamC = Parameter(label: nil, name: "c", type: "C", isVariadic: false, hasDefault: false)
private let kParamD = Parameter(label: nil, name: "d", type: "D", isVariadic: false, hasDefault: false)

private let kDocParamA = DocString.Entry(preDashWhitespaces: "", keyword: nil, name: .init("", "a"), preColonWhitespace: "", hasColon: true, description: [])
private let kDocParamB = DocString.Entry(preDashWhitespaces: "", keyword: nil, name: .init("", "b"), preColonWhitespace: "", hasColon: true, description: [])
private let kDocParamC = DocString.Entry(preDashWhitespaces: "", keyword: nil, name: .init("", "c"), preColonWhitespace: "", hasColon: true, description: [])
private let kDocParamE = DocString.Entry(preDashWhitespaces: "", keyword: nil, name: .init("", "e"), preColonWhitespace: "", hasColon: true, description: [])

final class ValidatingTests: XCTestCase {
    private func docString(with parameters: [DocString.Entry]) -> DocString {
        return DocString(
            description: [],
            parameterHeader: nil,
            parameters: parameters,
            returns: nil,
            throws: nil
        )
    }

    func testCommonSequenceFindsEmptyForEmptySequence() {
        let expected = [Parameter]()
        let sig = expected
        let doc = self.docString(with: [kDocParamA, kDocParamB, kDocParamC])
        let result = commonSequence(sig, doc)
        XCTAssertEqual(result, expected)
    }

    func testCommonSequenceFindsStrictSubsequence() {
        let expected0 = [kParamA, kParamB, kParamC]
        let sig0 = expected0
        let doc0 = self.docString(with: [kDocParamA, kDocParamB, kDocParamC])
        let result0 = commonSequence(sig0, doc0)
        XCTAssertEqual(result0, expected0)

        let sigParam1 = [kParamA, kParamB, kParamC]
        let sig1 = sigParam1
        let doc1 = self.docString(with: [kDocParamB, kDocParamC])
        let result1 = commonSequence(sig1, doc1)
        XCTAssertEqual(result1, [kParamB, kParamC])

        let sigParam2 = [kParamA, kParamB, kParamC]
        let sig2 = sigParam2
        let doc2 = self.docString(with: [kDocParamA, kDocParamB])
        let result2 = commonSequence(sig2, doc2)
        XCTAssertEqual(result2, [kParamA, kParamB])

        let sigParam3 = [kParamA, kParamB, kParamC]
        let sig3 = sigParam3
        let doc3 = self.docString(with: [kDocParamA, kDocParamC])
        let result3 = commonSequence(sig3, doc3)
        XCTAssertEqual(result3, [kParamA, kParamC])
    }

    func testCommonSequenceFindsLongestCommonSubsequence() {
        let sigParam = [kParamA, kParamD, kParamB, kParamC]
        let docParam = [kDocParamA, kDocParamB, kDocParamE, kDocParamC]
        let sig = sigParam
        let doc = self.docString(with: docParam)
        let result = commonSequence(sig, doc)
        XCTAssertEqual(result, [kParamA, kParamB, kParamC])
    }
}
