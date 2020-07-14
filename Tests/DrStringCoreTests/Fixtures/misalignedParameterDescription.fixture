// CHECK: Line 2 of `short`'s description is not properly vertically aligned
// CHECK-NOT: Line 3 of `short`'s description is not properly vertically aligned
// CHECK: Line 1 of `longer`'s description is not properly vertically aligned
/// function description
///
/// - parameter short:   short description
/// test short description continued
///                         test short description continued
/// - parameter longer: longer description
/// - parameter longest: longest description
func f(short: Int, longer: Int, longest: Int) {
}

// CHECK: Line 2 of `short`'s description is not properly vertically aligned
// CHECK-NOT: Line 3 of `short`'s description is not properly vertically aligned
// CHECK: Line 1 of `longer`'s description is not properly vertically aligned
/// function description
///
/// - parameters:
///   - short:   short description test
///   short description continued
///               test short description continued
///   - longer: longer description
///   - longest: longest description
func g(short: Int, longer: Int, longest: Int) {
}
