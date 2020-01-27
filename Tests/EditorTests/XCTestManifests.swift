#if !canImport(ObjectiveC)
import XCTest

extension DocStringDescriptionFormattingTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__DocStringDescriptionFormattingTests = [
        ("testDescriptionWithinColumnLimit", testDescriptionWithinColumnLimit),
        ("testDescriptionWithinColumnLimitWithInitialColumn", testDescriptionWithinColumnLimitWithInitialColumn),
        ("testEmptyLinesInDescriptionArePreserved", testEmptyLinesInDescriptionArePreserved),
        ("testExcessiveWhitespaceInEmptyLineAreRemoved", testExcessiveWhitespaceInEmptyLineAreRemoved),
        ("testFormattingEmptyDocString", testFormattingEmptyDocString),
        ("testLeadingWhiteSpacesInDescriptionArePreserved", testLeadingWhiteSpacesInDescriptionArePreserved),
        ("testLinesExceedingColumnLimitFlowsDownward", testLinesExceedingColumnLimitFlowsDownward),
        ("testLinesExceedingColumnLimitFlowsDownwardAndPreservesLeadingWhitespace", testLinesExceedingColumnLimitFlowsDownwardAndPreservesLeadingWhitespace),
        ("testSingleLeadingWhiteSpaceIsAddedIfNecessary", testSingleLeadingWhiteSpaceIsAddedIfNecessary),
    ]
}

extension DocStringParameterFormattingTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__DocStringParameterFormattingTests = [
        ("testContinuationLeadingSpacesArePreservedWhenNecessary0", testContinuationLeadingSpacesArePreservedWhenNecessary0),
        ("testContinuationLeadingSpacesArePreservedWhenNecessary1", testContinuationLeadingSpacesArePreservedWhenNecessary1),
        ("testContinuationLineIsPaddedToProperLevel0", testContinuationLineIsPaddedToProperLevel0),
        ("testContinuationLineIsPaddedToProperLevel1", testContinuationLineIsPaddedToProperLevel1),
        ("testCorrectContinuationLinesArePreservedForVerticalAlignment", testCorrectContinuationLinesArePreservedForVerticalAlignment),
        ("testExtraIndentationsAreRemovedAndFoldingWorksProperly", testExtraIndentationsAreRemovedAndFoldingWorksProperly),
        ("testGroupedMultipleParameters", testGroupedMultipleParameters),
        ("testGroupedMultipleParametersOverColumnLimit", testGroupedMultipleParametersOverColumnLimit),
        ("testGroupedMultipleParametersVerticalAligned", testGroupedMultipleParametersVerticalAligned),
        ("testSeparateMultipleParametersNoVerticalAlignment", testSeparateMultipleParametersNoVerticalAlignment),
        ("testSeparateMultipleParametersVerticalAlignment", testSeparateMultipleParametersVerticalAlignment),
        ("testSeparateSingleParameter", testSeparateSingleParameter),
        ("testSeparateSingleParameterColumnLimit", testSeparateSingleParameterColumnLimit),
        ("testSeparateSingleParameterLowercase", testSeparateSingleParameterLowercase),
        ("testSeparateSingleParameterMultlineDescription", testSeparateSingleParameterMultlineDescription),
        ("testSeparateSingleParameterMultlineDescriptionWithInitialColumn", testSeparateSingleParameterMultlineDescriptionWithInitialColumn),
        ("testSeparateSingleParameterWithMissingColon", testSeparateSingleParameterWithMissingColon),
        ("testVerticalAlign", testVerticalAlign),
    ]
}

extension DocStringReturnsFormattingTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__DocStringReturnsFormattingTests = [
        ("testFormattingBasicReturns", testFormattingBasicReturns),
        ("testFormattingBasicReturnsWithMissingColon", testFormattingBasicReturnsWithMissingColon),
        ("testFormattingColumnLimitPreservesLeadingWhitespaces", testFormattingColumnLimitPreservesLeadingWhitespaces),
        ("testFormattingColumnLimitRemoveExcessLeadingSpaceBeforeColon", testFormattingColumnLimitRemoveExcessLeadingSpaceBeforeColon),
        ("testFormattingColumnLimitWithAlignAfterColon", testFormattingColumnLimitWithAlignAfterColon),
        ("testFormattingColumnLimitWithoutAlignAfterColon", testFormattingColumnLimitWithoutAlignAfterColon),
        ("testFormattingLowercaseKeyword", testFormattingLowercaseKeyword),
    ]
}

extension DocStringSectionSeparationFormattingTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__DocStringSectionSeparationFormattingTests = [
        ("testDescriptionSeparatorDoesNotGetAddedIfItsTheLastSection", testDescriptionSeparatorDoesNotGetAddedIfItsTheLastSection),
        ("testDescriptionSeparatorDoesNotGetAddedIfUnnecessary", testDescriptionSeparatorDoesNotGetAddedIfUnnecessary),
        ("testDescriptionSeparatorGetsAdded", testDescriptionSeparatorGetsAdded),
        ("testFormattingEmptyDocString", testFormattingEmptyDocString),
        ("testParameterSeparatorDoesNotGetAddedIfItsTheLastSection", testParameterSeparatorDoesNotGetAddedIfItsTheLastSection),
        ("testParameterSeparatorGetsAdded", testParameterSeparatorGetsAdded),
        ("testParametersSeparatorDoesNotGetAddedIfUnnecessary", testParametersSeparatorDoesNotGetAddedIfUnnecessary),
        ("testThrowsSeparatorDoesNotGetAddedIfItsTheLastSection", testThrowsSeparatorDoesNotGetAddedIfItsTheLastSection),
        ("testThrowsSeparatorDoesNotGetAddedIfUnnecessary", testThrowsSeparatorDoesNotGetAddedIfUnnecessary),
        ("testThrowsSeparatorGetsAdded", testThrowsSeparatorGetsAdded),
    ]
}

extension DocStringSeparatorTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__DocStringSeparatorTests = [
        ("testAddsMissingSeparatorAfterDescription", testAddsMissingSeparatorAfterDescription),
        ("testAddsMissingSeparatorAfterParameters", testAddsMissingSeparatorAfterParameters),
        ("testAddsMissingSeparatorAfterThrows", testAddsMissingSeparatorAfterThrows),
        ("testDoesNotAddSeparatorAfterDescriptionIfNotNecessary", testDoesNotAddSeparatorAfterDescriptionIfNotNecessary),
        ("testDoesNotAddSeparatorAfterDescriptionIfNotRequired", testDoesNotAddSeparatorAfterDescriptionIfNotRequired),
        ("testDoesNotAddSeparatorAfterParametersIfNotNecessary", testDoesNotAddSeparatorAfterParametersIfNotNecessary),
        ("testDoesNotAddSeparatorAfterParametersIfNotRequired", testDoesNotAddSeparatorAfterParametersIfNotRequired),
        ("testDoesNotAddSeparatorAfterThrowsIfNotNecessary", testDoesNotAddSeparatorAfterThrowsIfNotNecessary),
        ("testDoesNotAddSeparatorAfterThrowsIfNotRequired", testDoesNotAddSeparatorAfterThrowsIfNotRequired),
    ]
}

extension DocStringThrowsFormattingTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__DocStringThrowsFormattingTests = [
        ("testFormattingBasicThrows", testFormattingBasicThrows),
        ("testFormattingBasicThrowsWithMissingColon", testFormattingBasicThrowsWithMissingColon),
        ("testFormattingColumnLimitPreservesExcessLeadingSpaceAfterColon", testFormattingColumnLimitPreservesExcessLeadingSpaceAfterColon),
        ("testFormattingColumnLimitPreservesLeadingWhitespaces", testFormattingColumnLimitPreservesLeadingWhitespaces),
        ("testFormattingColumnLimitRemoveExcessLeadingSpaceBeforeColon", testFormattingColumnLimitRemoveExcessLeadingSpaceBeforeColon),
        ("testFormattingColumnLimitWithAlignAfterColon", testFormattingColumnLimitWithAlignAfterColon),
        ("testFormattingColumnLimitWithoutAlignAfterColon", testFormattingColumnLimitWithoutAlignAfterColon),
        ("testFormattingLowercaseKeyword", testFormattingLowercaseKeyword),
    ]
}

extension FormatRangeTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__FormatRangeTests = [
        ("testAt_0_0", testAt_0_0),
        ("testAt_0_1", testAt_0_1),
        ("testAt_0_3", testAt_0_3),
        ("testAt_0_5", testAt_0_5),
        ("testAt_0_6", testAt_0_6),
        ("testAt_0_8", testAt_0_8),
        ("testAt_4_4", testAt_4_4),
        ("testAt_5_8", testAt_5_8),
        ("testAt_8_8", testAt_8_8),
    ]
}

extension LineFoldingTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__LineFoldingTests = [
        ("testLineExceedingLimitFlowsDownward", testLineExceedingLimitFlowsDownward),
        ("testLineWithinLimitRemains", testLineWithinLimitRemains),
        ("testWordExceedingLimitFormItsOwnLine", testWordExceedingLimitFormItsOwnLine),
    ]
}

extension ParameterPlaceholderTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ParameterPlaceholderTests = [
        ("testGeneratePlaceholderAtAnywhereButMiddle", testGeneratePlaceholderAtAnywhereButMiddle),
        ("testGeneratePlaceholderAtBeginning", testGeneratePlaceholderAtBeginning),
        ("testGeneratePlaceholderAtEnd", testGeneratePlaceholderAtEnd),
        ("testGeneratePlaceholderAtMiddle", testGeneratePlaceholderAtMiddle),
        ("testGeneratePlaceholderWhileKeepingRedundantDoc", testGeneratePlaceholderWhileKeepingRedundantDoc),
        ("testNoPlaceholderNecessary", testNoPlaceholderNecessary),
    ]
}

extension ReturnsPlaceholderTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ReturnsPlaceholderTests = [
        ("testGeneratingReturns", testGeneratingReturns),
        ("testGeneratingReturnsIgnored", testGeneratingReturnsIgnored),
        ("testGeneratingReturnsNotNecessary", testGeneratingReturnsNotNecessary),
        ("testNotGeneratingReturns", testNotGeneratingReturns),
    ]
}

extension ThrowsPlaceholderTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__ThrowsPlaceholderTests = [
        ("testGeneratingThrows", testGeneratingThrows),
        ("testGeneratingThrowsIgnored", testGeneratingThrowsIgnored),
        ("testGeneratingThrowsNotNecessary", testGeneratingThrowsNotNecessary),
        ("testNotGeneratingThrows", testNotGeneratingThrows),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DocStringDescriptionFormattingTests.__allTests__DocStringDescriptionFormattingTests),
        testCase(DocStringParameterFormattingTests.__allTests__DocStringParameterFormattingTests),
        testCase(DocStringReturnsFormattingTests.__allTests__DocStringReturnsFormattingTests),
        testCase(DocStringSectionSeparationFormattingTests.__allTests__DocStringSectionSeparationFormattingTests),
        testCase(DocStringSeparatorTests.__allTests__DocStringSeparatorTests),
        testCase(DocStringThrowsFormattingTests.__allTests__DocStringThrowsFormattingTests),
        testCase(FormatRangeTests.__allTests__FormatRangeTests),
        testCase(LineFoldingTests.__allTests__LineFoldingTests),
        testCase(ParameterPlaceholderTests.__allTests__ParameterPlaceholderTests),
        testCase(ReturnsPlaceholderTests.__allTests__ReturnsPlaceholderTests),
        testCase(ThrowsPlaceholderTests.__allTests__ThrowsPlaceholderTests),
    ]
}
#endif
