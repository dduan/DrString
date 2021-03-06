import Models
@testable import Editor
import XCTest

final class DocStringDescriptionFormattingTests: XCTestCase {
    func testFormattingEmptyDocString() {
        let doc = DocString(
            location: .init(),
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
            separations: []
        )
        XCTAssertTrue(result.isEmpty)
    }

    func testDescriptionWithinColumnLimit() {
        let doc = DocString(
            location: .init(),
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
                separations: []
            ),
            expectation
        )
    }

    func testDescriptionWithinColumnLimitWithInitialColumn() {
        let doc = DocString(
            location: .init(),
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
                separations: []
            ),
            expectation
        )
    }

    func testEmptyLinesInDescriptionArePreserved() {
        let doc = DocString(
            location: .init(),
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
                separations: []
            ),
            expectation
        )
    }

    func testLeadingWhiteSpacesInDescriptionArePreserved() {
        let doc = DocString(
            location: .init(),
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
                separations: []
            ),
            expectation
        )
    }

    func testSingleLeadingWhiteSpaceIsAddedIfNecessary() {
        let doc = DocString(
            location: .init(),
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
                separations: []
            ),
            expectation
        )
    }

    func testExcessiveWhitespaceInEmptyLineAreRemoved() {
        let doc = DocString(
            location: .init(),
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
                separations: []
            ),
            expectation
        )
    }

    func testLinesExceedingColumnLimitFlowsDownward() {
        let doc = DocString(
            location: .init(),
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
                separations: []
            ),
            expectation
        )
    }

    func testLinesExceedingColumnLimitFlowsDownwardAndPreservesLeadingWhitespace() {
        let doc = DocString(
            location: .init(),
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
                separations: []
            ),
            expectation
        )
    }
}
