// CHECK: `throws` should start with exactly 1 space before `-`
///   - throws: throws stuff
func badThrowsFormat1() throws {
}

// CHECK: There should be exactly 1 space between `-` and `throws`
/// -   throws: throws stuff
func badThrowsFormat2() throws {
}

// CHECK: For `throws`, there should be no whitespace before `:`
/// - throws : throws stuff
func badThrowsFormat3() throws {
}
