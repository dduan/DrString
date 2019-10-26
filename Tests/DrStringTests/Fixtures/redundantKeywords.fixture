// CHECK: Redundant documentation for `throws`
/// description
/// - parameter a: description for a
/// - throws: wat
/// - returns: zero
func redundantKeywords0(a: Int) -> Int { 0 }

// CHECK: Redundant documentation for `returns`
/// description
/// - parameter a: description for a
/// - throws: wat
/// - returns: zero
func redundantKeywords1(a: Int) throws {}

// CHECK: Redundant documentation for `throws`
// CHECK: Redundant documentation for `returns`
/// description
/// - parameter a: description for a
/// - throws: wat
/// - returns: zero
func redundantKeywords2(a: Int) {}

// CHECK: Redundant documentation for `returns`
/// description
/// - parameter a: description for a
/// - returns: zero
func redundantKeywords3(a: Int) {}
