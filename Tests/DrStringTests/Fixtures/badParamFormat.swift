// CHECK: Parameter `a1` should start with exactly 1 space before `-`
// CHECK: `b1` should have exactly 1 space between `-` and `parameter`
// CHECK: `c1` should be proceeded by `{{(P|p)arameter}}`, found `parameterz`
// CHECK: There should be exactly 1 space between `{{(P|p)arameter}}` and `d1`
// CHCEK: For parameter `e1`, there should be no whitespace before `:`
///  - parameter a1: a description
/// -   parameter b1: another description
/// - parameterz c1: yet another description
/// - parameter   d1: d1 description
/// - parameter e1 : e1 description
func badParamFormat1(a1: Int, b1: Int, c1: Int, d1: Int, e1: Int) {
}

// CHECK: Parameter `a2` should start with exactly 3 spaces before `-`
// CHCEK: For `e1`, there should be no whitespace before `:`
/// - Parameters
///  - a2: a description
///   - b2: another description
///   - e1 : e1 description
func badParamFormat2(a2: Int, b2: Int, e1: Int) {
}
