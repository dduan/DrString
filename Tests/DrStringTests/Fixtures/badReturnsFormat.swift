// CHECK: `returns` should start with exactly 1 space before `-`
///   - returns: returns stuff
func badReturnsFormat1() -> Int {
    fatalError()
}

// CHECK: There should be exactly 1 space between `-` and `returns`
/// -   returns: returns stuff
func badReturnsFormat2() -> Int {
    fatalError()
}

// CHECK: For `returns`, there should be no whitespace before `:`
/// - returns : returns stuff
func badReturnsFormat3() -> Int {
    fatalError()
}
