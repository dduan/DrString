import Models
@testable import Editor
import XCTest

final class DocStringDescriptionFormattingTests: XCTestCase {
    func testFormattingEmptyDocString() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [],
            returns: nil,
            throws: nil)
        let result = doc.reformat(
            initialColumn: 0,
            columnLimit: 100,
            verticalAlign: false,
            alignAfterColon: [],
            firstLetterUpperCase: true,
            parameterStyle: .whatever,
            separations: [],
            startLine: nil,
            endLine: nil
        )
        XCTAssertTrue(result.isEmpty)
    }

    func testDescriptionWithinColumnLimit() {
        let doc = DocString(
            description: [
                .init(" ", "This is a line of description"),
                .init(" ", "This is another line of description"),
            ],
            parameterHeader: nil,
            parameters: [],
            returns: nil,
            throws: nil)

        let expectation = [
            "/// This is a line of description",
            "/// This is another line of description",
        ]

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 0,
                columnLimit: 100,
                verticalAlign: false,
                alignAfterColon: [],
                firstLetterUpperCase: true,
                parameterStyle: .whatever,
                separations: [],
                startLine: nil,
                endLine: nil
            ),
            expectation
        )
    }

    func testDescriptionWithinColumnLimitWithInitialColumn() {
        let doc = DocString(
            description: [
                .init(" ", "This is a line of description"),
                .init(" ", "This is another line of description"),
            ],
            parameterHeader: nil,
            parameters: [],
            returns: nil,
            throws: nil)

        let expectation = [
            "/// This is a line of description",
            "/// This is another line of description",
        ]

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 8,
                columnLimit: 100,
                verticalAlign: false,
                alignAfterColon: [],
                firstLetterUpperCase: true,
                parameterStyle: .whatever,
                separations: [],
                startLine: nil,
                endLine: nil
            ),
            expectation
        )
    }

    func testEmptyLinesInDescriptionArePreserved() {
        let doc = DocString(
            description: [
                .init(" ", "This is a line of description"),
                .init("", ""),
                .init("", ""),
                .init(" ", "This is another line of description"),
                .init("", ""),
            ],
            parameterHeader: nil,
            parameters: [],
            returns: nil,
            throws: nil)

        let expectation = [
            "/// This is a line of description",
            "///",
            "///",
            "/// This is another line of description",
            "///",
        ]

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 8,
                columnLimit: 100,
                verticalAlign: false,
                alignAfterColon: [],
                firstLetterUpperCase: true,
                parameterStyle: .whatever,
                separations: [],
                startLine: nil,
                endLine: nil
            ),
            expectation
        )
    }

    func testLeadingWhiteSpacesInDescriptionArePreserved() {
        let doc = DocString(
            description: [
                .init(" ", "This is a line of description"),
                .init("     ", "This is another line of description"),
            ],
            parameterHeader: nil,
            parameters: [],
            returns: nil,
            throws: nil)

        let expectation = [
            "/// This is a line of description",
            "///     This is another line of description",
        ]

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 8,
                columnLimit: 100,
                verticalAlign: false,
                alignAfterColon: [],
                firstLetterUpperCase: true,
                parameterStyle: .whatever,
                separations: [],
                startLine: nil,
                endLine: nil
            ),
            expectation
        )
    }

    func testSingleLeadingWhiteSpaceIsAddedIfNecessary() {
        let doc = DocString(
            description: [
                .init("", "This is a line of description"),
                .init("", ""),
                .init(" ", "This is a second line of description"),
                .init("     ", "This is another line of description"),
            ],
            parameterHeader: nil,
            parameters: [],
            returns: nil,
            throws: nil)

        let expectation = [
            "/// This is a line of description",
            "///",
            "/// This is a second line of description",
            "///     This is another line of description",
        ]

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 0,
                columnLimit: 100,
                verticalAlign: false,
                alignAfterColon: [],
                firstLetterUpperCase: true,
                parameterStyle: .whatever,
                separations: [],
                startLine: nil,
                endLine: nil
            ),
            expectation
        )
    }

    func testExcessiveWhitespaceInEmptyLineAreRemoved() {
        let doc = DocString(
            description: [
                .init(" ", "This is a line of description"),
                .init("     ", ""),
                .init(" ", "This is another line of description"),
            ],
            parameterHeader: nil,
            parameters: [],
            returns: nil,
            throws: nil)

        let expectation = [
            "/// This is a line of description",
            "///",
            "/// This is another line of description",
        ]

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 0,
                columnLimit: 100,
                verticalAlign: false,
                alignAfterColon: [],
                firstLetterUpperCase: true,
                parameterStyle: .whatever,
                separations: [],
                startLine: nil,
                endLine: nil
            ),
            expectation
        )
    }

    func testLinesExceedingColumnLimitFlowsDownward() {
        let doc = DocString(
            description: [
                .init(" ", "This is a line of description"),
                .init("", ""),
                .init(" ", "This is another line of description"),
            ],
            parameterHeader: nil,
            parameters: [],
            returns: nil,
            throws: nil)

        let expectation = [
            "/// This is a line of description",
            "///",
            "/// This is another line of",
            "/// description",
        ]

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 41,
                columnLimit: 79,
                verticalAlign: false,
                alignAfterColon: [],
                firstLetterUpperCase: true,
                parameterStyle: .whatever,
                separations: [],
                startLine: nil,
                endLine: nil
            ),
            expectation
        )
    }

    func testLinesExceedingColumnLimitFlowsDownwardAndPreservesLeadingWhitespace() {
        let doc = DocString(
            description: [
                .init(" ", "This is a line of description"),
                .init("", ""),
                .init("   ", "This is another line of description"),
            ],
            parameterHeader: nil,
            parameters: [],
            returns: nil,
            throws: nil)

        let expectation = [
            "/// This is a line of description",
            "///",
            "///   This is another line of",
            "///   description",
        ]

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 41,
                columnLimit: 79,
                verticalAlign: false,
                alignAfterColon: [],
                firstLetterUpperCase: true,
                parameterStyle: .whatever,
                separations: [],
                startLine: nil,
                endLine: nil
            ),
            expectation
        )
    }
}
