// CHECK: Parameter `a1` should start with exactly 1 space before `-`
///  - parameter a1: a description
func badParamFormat1(a1: Int) {
}

// CHECK: Parameter `a2` should start with exactly 3 spaces before `-`
/// - Parameters
///  - a2: a description
func badParamFormat2(a2: Int) {
}
