// CHECK: For `a`, `parameter` is misspelled as
// CHECK: For `b`, `parameter` is misspelled as
// CHECK: `throws` is misspelled as
// CHECK: `returns` is misspelled as
/// function description
///
/// - parameterz a: a description
/// - Parameter b: b description
///
/// - Throws: throws description
/// - Returns: returns description
func lowercaseKeywords1(a: Int, b: Int) throws -> Int {
    return 0
}

// CHECK: `throws` is misspelled as
// CHECK: `returns` is misspelled as
/// function description
///
/// - Parameters:
///   - a: a description
///   - b: b description
///
/// - Throws: throws description
/// - Returns: returns description
func lowercaseKeywords2(a: Int, b: Int) throws -> Int {
    return 0
}

// CHECK: `throws` is misspelled as
// CHECK: `returns` is misspelled as
/// function description
///
/// - Parameters:
///   - a: a description
///   - b: b description
///
/// - Throw: throws description
/// - Return: returns description
func lowercaseKeywords3(a: Int, b: Int) throws -> Int {
    return 0
}
