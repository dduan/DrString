// CHECK: For `a`, `Parameter` is misspelled as
// CHECK: For `b`, `Parameter` is misspelled as
// CHECK: `Throws` is misspelled as
// CHECK: `Returns` is misspelled as
/// function description
///
/// - Parameterz a: a description
/// - parameter b: b description
///
/// - throws: throws description
/// - returns: returns description
func uppercaseKeywords1(a: Int, b: Int) throws -> Int {
    return 0
}

// CHECK: `Throws` is misspelled as
// CHECK: `Returns` is misspelled as
/// function description
///
/// - parameters:
///   - a: a description
///   - b: b description
///
/// - throws: throws description
/// - returns: returns description
func uppercaseKeywords2(a: Int, b: Int) throws -> Int {
    return 0
}

// CHECK: `Throws` is misspelled as
// CHECK: `Returns` is misspelled as
/// function description
///
/// - parameters:
///   - a: a description
///   - b: b description
///
/// - throw: throws description
/// - return: returns description
func uppercaseKeywords3(a: Int, b: Int) throws -> Int {
    return 0
}
