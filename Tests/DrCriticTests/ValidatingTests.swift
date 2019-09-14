/*
@testable import DrCritic
import DrCrawler
import DrDecipher
import XCTest

private let kParamA = FunctionSignature.Parameter(name: "a", type: "A")
private let kParamB = FunctionSignature.Parameter(name: "b", type: "B")
private let kParamC = FunctionSignature.Parameter(name: "c", type: "C")
private let kParamD = FunctionSignature.Parameter(name: "d", type: "D")

private let kDocParamA = DocString.Parameter(name: "a", description: [])
private let kDocParamB = DocString.Parameter(name: "b", description: [])
private let kDocParamC = DocString.Parameter(name: "c", description: [])
private let kDocParamE = DocString.Parameter(name: "e", description: [])

final class ValidatingTests: XCTestCase {
    private func signature(with parameters: [FunctionSignature.Parameter]) -> FunctionSignature {
        return FunctionSignature(
            name: "sig",
            parameters: parameters,
            throws: false,
            returnType: nil
        )
    }

    private func docString(with parameters: [DocString.Parameter]) -> DocString {
        return DocString(
            description: [],
            parameters: parameters,
            returns: [],
            throws: []
        )
    }

    func testCommonSequenceFindsEmptyForEmptySequence() {
        let expected = [FunctionSignature.Parameter]()
        let sig = self.signature(with: expected)
        let doc = self.docString(with: [kDocParamA, kDocParamB, kDocParamC])
        let result = commonSequence(sig, doc)
        XCTAssertEqual(result, expected)
    }

    func testCommonSequenceFindsStrictSubsequence() {
        let expected0 = [kParamA, kParamB, kParamC]
        let sig0 = self.signature(with: expected0)
        let doc0 = self.docString(with: [kDocParamA, kDocParamB, kDocParamC])
        let result0 = commonSequence(sig0, doc0)
        XCTAssertEqual(result0, expected0)

        let sigParam1 = [kParamA, kParamB, kParamC]
        let sig1 = self.signature(with: sigParam1)
        let doc1 = self.docString(with: [kDocParamB, kDocParamC])
        let result1 = commonSequence(sig1, doc1)
        XCTAssertEqual(result1, [kParamB, kParamC])

        let sigParam2 = [kParamA, kParamB, kParamC]
        let sig2 = self.signature(with: sigParam2)
        let doc2 = self.docString(with: [kDocParamA, kDocParamB])
        let result2 = commonSequence(sig2, doc2)
        XCTAssertEqual(result2, [kParamA, kParamB])

        let sigParam3 = [kParamA, kParamB, kParamC]
        let sig3 = self.signature(with: sigParam3)
        let doc3 = self.docString(with: [kDocParamA, kDocParamC])
        let result3 = commonSequence(sig3, doc3)
        XCTAssertEqual(result3, [kParamA, kParamC])
    }

    func testCommonSequenceFindsLongestCommonSubsequence() {
        let sigParam = [kParamA, kParamD, kParamB, kParamC]
        let docParam = [kDocParamA, kDocParamB, kDocParamE, kDocParamC]
        let sig = self.signature(with: sigParam)
        let doc = self.docString(with: docParam)
        let result = commonSequence(sig, doc)
        XCTAssertEqual(result, [kParamA, kParamB, kParamC])
    }
}
*/
