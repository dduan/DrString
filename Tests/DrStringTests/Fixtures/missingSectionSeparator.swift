/// CHECK: Overall description should end with an empty line
/// CHECK: `b`'s description should end with an empty line
/// CHECK: `throws`'s description should end with an empty line
/// Description
/// Description continues
/// - parameter a: description for a
///                  a continued
/// - parameter b: description for b
/// - throws: description for throws
/// - returns: description for returns
func missingSeparatorLines0(a: Int, b: Int) throws -> Int { 0 }

/// CHECK: Overall description should end with an empty line
/// CHECK: `b`'s description should end with an empty line
/// Description
/// Description continues
/// - Parameters
///   - a: description for a
///   - b: description for b
///        b continued
/// - Returns: description for returns
func missingSeparatorLines1(a: Int, b: Int) -> Int { 0 }
