// CHECK: Parameter `a1` should start with exactly 1 space before `-`
// CHECK: `b1` should have exactly 1 space between `-` and `parameter`
///  - parameter a1: a description
/// -   parameter b1: another description
func badParamFormat1(a1: Int, b1: Int) {
}

// CHECK: Parameter `a2` should start with exactly 3 spaces before `-`
/// - Parameters
///  - a2: a description
///   - b2: another description
func badParamFormat2(a2: Int, b2: Int) {
}
