@testable import Decipher
@testable import Editor
import XCTest

final class DocStringParameterFormattingTests: XCTestCase {
    func testSeparateSingleParameter() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "foo's description")
                    ])
            ],
            returns: nil,
            throws: nil)

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 0,
                columnLimit: 100,
                verticalAlign: false,
                alignAfterColon: [.parameters],
                firstLetterUpperCase: true,
                parameterStyle: .separate,
                separations: []
            ),
            [
                "/// - Parameter foo: foo's description"
            ]
        )
    }

    func testSeparateSingleParameterWithMissingColon() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    hasColon: false,
                    description: [
                        .init(" ", "foo's description")
                    ])
            ],
            returns: nil,
            throws: nil)

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 0,
                columnLimit: 100,
                verticalAlign: false,
                alignAfterColon: [.parameters],
                firstLetterUpperCase: true,
                parameterStyle: .separate,
                separations: []
            ),
            [
                "/// - Parameter foo: foo's description"
            ]
        )
    }

    func testSeparateSingleParameterLowercase() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "foo's description")
                    ])
            ],
            returns: nil,
            throws: nil)

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 0,
                columnLimit: 100,
                verticalAlign: false,
                alignAfterColon: [.parameters],
                firstLetterUpperCase: false,
                parameterStyle: .separate,
                separations: []
            ),
            [
                "/// - parameter foo: foo's description"
            ]
        )
    }

    func testSeparateSingleParameterMultlineDescription() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "foo's description"),
                        .init(" ", "line 2 of foo's description"),
                    ])
            ],
            returns: nil,
            throws: nil)

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 0,
                columnLimit: 100,
                verticalAlign: false,
                alignAfterColon: [.parameters],
                firstLetterUpperCase: true,
                parameterStyle: .separate,
                separations: []
            ),
            [
                "/// - Parameter foo: foo's description",
                "///                  line 2 of foo's description",
            ]
        )
    }

    func testSeparateSingleParameterMultlineDescriptionWithInitialColumn() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "foo's description"),
                        .init(" ", "line 2 of foo's description"),
                    ])
            ],
            returns: nil,
            throws: nil)

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 4,
                columnLimit: 100,
                verticalAlign: false,
                alignAfterColon: [.parameters],
                firstLetterUpperCase: true,
                parameterStyle: .separate,
                separations: []
            ),
            [
                "/// - Parameter foo: foo's description",
                "///                  line 2 of foo's description",
            ]
        )
    }

    func testSeparateSingleParameterColumnLimit() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "foo's description"),
                        .init(" ", "line 2 of foo's description"),
                    ])
            ],
            returns: nil,
            throws: nil)

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 0,
                columnLimit: 40,
                verticalAlign: false,
                alignAfterColon: [.parameters],
                firstLetterUpperCase: true,
                parameterStyle: .separate,
                separations: []
            ),
            [
                "/// - Parameter foo: foo's description",
                "///                  line 2 of foo's",
                "///                  description",
            ]
        )
    }

    func testSeparateMultipleParametersNoVerticalAlignment() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "foo's description"),
                        .init(" ", "line 2 of foo's description"),
                    ]),
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "barbaz"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "barbaz's description"),
                        .init(" ", "line 2 of barbaz's description"),
                    ]),
            ],
            returns: nil,
            throws: nil)

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 0,
                columnLimit: 100,
                verticalAlign: false,
                alignAfterColon: [.parameters],
                firstLetterUpperCase: true,
                parameterStyle: .separate,
                separations: []
            ),
            [
                "/// - Parameter foo: foo's description",
                "///                  line 2 of foo's description",
                "/// - Parameter barbaz: barbaz's description",
                "///                     line 2 of barbaz's description",
            ]
        )
    }

    func testSeparateMultipleParametersVerticalAlignment() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "foo's description"),
                        .init(" ", "line 2 of foo's description"),
                    ]),
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "barbaz"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "barbaz's description"),
                        .init(" ", "line 2 of barbaz's description"),
                    ]),
            ],
            returns: nil,
            throws: nil)

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 0,
                columnLimit: 100,
                verticalAlign: true,
                alignAfterColon: [.parameters],
                firstLetterUpperCase: true,
                parameterStyle: .separate,
                separations: []
            ),
            [
                "/// - Parameter foo:    foo's description",
                "///                     line 2 of foo's description",
                "/// - Parameter barbaz: barbaz's description",
                "///                     line 2 of barbaz's description",
            ]
        )
    }

    func testGroupedMultipleParameters() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "foo's description"),
                        .init(" ", "line 2 of foo's description"),
                    ]),
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "barbaz"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "barbaz's description"),
                        .init(" ", "line 2 of barbaz's description"),
                    ]),
            ],
            returns: nil,
            throws: nil)

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 0,
                columnLimit: 100,
                verticalAlign: false,
                alignAfterColon: [.parameters],
                firstLetterUpperCase: true,
                parameterStyle: .grouped,
                separations: []
            ),
            [
                "/// - Parameters:",
                "///   - foo: foo's description",
                "///          line 2 of foo's description",
                "///   - barbaz: barbaz's description",
                "///             line 2 of barbaz's description",
            ]
        )
    }

    func testGroupedMultipleParametersVerticalAligned() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "foo's description"),
                        .init(" ", "line 2 of foo's description"),
                    ]),
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "barbaz"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "barbaz's description"),
                        .init(" ", "line 2 of barbaz's description"),
                    ]),
            ],
            returns: nil,
            throws: nil)

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 0,
                columnLimit: 100,
                verticalAlign: true,
                alignAfterColon: [.parameters],
                firstLetterUpperCase: true,
                parameterStyle: .grouped,
                separations: []
            ),
            [
                "/// - Parameters:",
                "///   - foo:    foo's description",
                "///             line 2 of foo's description",
                "///   - barbaz: barbaz's description",
                "///             line 2 of barbaz's description",
            ]
        )
    }

    func testGroupedMultipleParametersOverColumnLimit() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "foo's description"),
                        .init(" ", "line 2 of foo's description"),
                    ]),
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "barbaz"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "barbaz's description"),
                        .init(" ", "line 2 of barbaz's description"),
                    ]),
            ],
            returns: nil,
            throws: nil)

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 0,
                columnLimit: 40,
                verticalAlign: false,
                alignAfterColon: [.parameters],
                firstLetterUpperCase: true,
                parameterStyle: .grouped,
                separations: []
            ),
            [
                "/// - Parameters:",
                "///   - foo: foo's description",
                "///          line 2 of foo's description",
                "///   - barbaz: barbaz's description",
                "///             line 2 of barbaz's",
                "///             description",
            ]
        )
    }

    func testContinuationLineIsPaddedToProperLevel0() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "foo's description"),
                        .init("             ", "continues"),
                ])
            ],
            returns: nil,
            throws: nil)

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 0,
                columnLimit: 100,
                verticalAlign: false,
                alignAfterColon: [.parameters],
                firstLetterUpperCase: true,
                parameterStyle: .separate,
                separations: []
            ),
            [
                "/// - Parameter foo: foo's description",
                "///                  continues",
            ]
        )
    }

    func testContinuationLineIsPaddedToProperLevel1() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "foo's description"),
                        .init("                    ", "continues"),
                ])
            ],
            returns: nil,
            throws: nil)

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 0,
                columnLimit: 100,
                verticalAlign: false,
                alignAfterColon: [.parameters],
                firstLetterUpperCase: true,
                parameterStyle: .separate,
                separations: []
            ),
            [
                "/// - Parameter foo: foo's description",
                "///                    continues",
            ]
        )
    }

    func testContinuationLeadingSpacesArePreservedWhenNecessary0() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "foo's description"),
                        .init("              ", "continues"),
                ])
            ],
            returns: nil,
            throws: nil)

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 0,
                columnLimit: 100,
                verticalAlign: false,
                alignAfterColon: [],
                firstLetterUpperCase: true,
                parameterStyle: .separate,
                separations: []
            ),
            [
                "/// - Parameter foo: foo's description",
                "///              continues",
            ]
        )
    }

    func testContinuationLeadingSpacesArePreservedWhenNecessary1() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init(" ", "foo's description"),
                        .init("                  ", "continues"),
                ])
            ],
            returns: nil,
            throws: nil)

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 0,
                columnLimit: 100,
                verticalAlign: false,
                alignAfterColon: [],
                firstLetterUpperCase: true,
                parameterStyle: .separate,
                separations: []
            ),
            [
                "/// - Parameter foo: foo's description",
                "///                  continues",
            ]
        )
    }

    func testExtraIndentationsAreRemovedAndFoldingWorksProperly() {
        let doc = DocString(
            description: [],
            parameterHeader: nil,
            parameters: [
                .init(
                    preDashWhitespaces: " ",
                    keyword: .init(" ", "Parameter"),
                    name: .init(" ", "foo"),
                    preColonWhitespace: "",
                    hasColon: true,
                    description: [
                        .init("  ", "foo's description continues"),
                        .init("                   ", "it continues"),
                ])
            ],
            returns: nil,
            throws: nil)

        XCTAssertEqual(
            doc.reformat(
                initialColumn: 0,
                columnLimit: 40,
                verticalAlign: false,
                alignAfterColon: [.parameters],
                firstLetterUpperCase: true,
                parameterStyle: .separate,
                separations: []
            ),
            [
                "/// - Parameter foo: foo's description",
                "///                  continues",
                "///                  it continues",
            ]
        )
    }

    func testVerticalAlign() {
        let doc = DocString(
             description: [],
             parameterHeader: nil,
             parameters: [
                 .init(
                     preDashWhitespaces: " ",
                     keyword: .init(" ", "Parameter"),
                     name: .init(" ", "foo"),
                     preColonWhitespace: "",
                     hasColon: true,
                     description: [
                         .init("    ", "foo's description continues"),
                         .init("   ", "foo's description continues"),
                         .init("                    ", "it continues"),
                         .init("                    ", "it continues"),
                    ]),

                 .init(
                     preDashWhitespaces: " ",
                     keyword: .init(" ", "Parameter"),
                     name: .init(" ", "barzz"),
                     preColonWhitespace: "",
                     hasColon: true,
                     description: [
                         .init("  ", "barzz's des"),
                    ]),
             ],
             returns: nil,
             throws: nil)

         XCTAssertEqual(
             doc.reformat(
                 initialColumn: 0,
                 columnLimit: 40,
                 verticalAlign: true,
                 alignAfterColon: [.parameters],
                 firstLetterUpperCase: true,
                 parameterStyle: .separate,
                 separations: []
             ),
             [
                 "/// - Parameter foo:   foo's description",
                 "///                    continues",
                 "///                    foo's description",
                 "///                    continues",
                 "///                    it continues",
                 "///                    it continues",
                 "/// - Parameter barzz: barzz's des"
             ]
         )
    }

    func testCorrectContinuationLinesArePreservedForVerticalAlignment() {
        let doc = DocString(
               description: [],
               parameterHeader: nil,
               parameters: [
                   .init(
                       preDashWhitespaces: " ",
                       keyword: .init(" ", "Parameter"),
                       name: .init(" ", "mapPadding"),
                       preColonWhitespace: "",
                       hasColon: true,
                       description: [
                           .init("        ", "The padding for the map view in which the pin will"),
                           .init("                                 ", "appear to be centered."),
                      ]),

                   .init(
                       preDashWhitespaces: " ",
                       keyword: .init(" ", "Parameter"),
                       name: .init(" ", "presentationDelay"),
                       preColonWhitespace: "",
                       hasColon: true,
                       description: [
                           .init(" ", "The delay before the"),
                      ]),
               ],
               returns: nil,
               throws: nil)

           XCTAssertEqual(
               doc.reformat(
                   initialColumn: 4,
                   columnLimit: 110,
                   verticalAlign: true,
                   alignAfterColon: [.parameters],
                   firstLetterUpperCase: true,
                   parameterStyle: .separate,
                   separations: []
               ),
               [
                    "/// - Parameter mapPadding:        The padding for the map view in which the pin will",
                    "///                                 appear to be centered.",
                    "/// - Parameter presentationDelay: The delay before the",
                ]
           )
    }
}
