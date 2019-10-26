// CHECK: `Parameters` should start with exactly 1 space before `-`
/// Descriptions
///  - Parameters:
///   - foo: foo's description
///   - bar: bar's description
func f0(foo: Int, bar: Int) {}

// CHECK: `parameters` should start with exactly 1 space before `-`
/// Descriptions
///  - parameters:
///   - foo: foo's description
///   - bar: bar's description
func f4(foo: Int, bar: Int) {}

// CHECK: There should be exactly 1 space between `-` and `Parameters`
/// Descriptions
/// -   Parameters:
///   - foo: foo's description
///   - bar: bar's description
func f1(foo: Int, bar: Int) {}

// CHECK: For `Parameters`, there should be no whitespace before `:`
/// Descriptions
/// - Parameters :
///   - foo: foo's description
///   - bar: bar's description
func f2(foo: Int, bar: Int) {}

// CHECK: `Parameters` is misspelled as
/// Descriptions
/// - Parametersss:
///   - foo: foo's description
///   - bar: bar's description
func f3(foo: Int, bar: Int) {}

// CHECK: `:` should be the last character on the line for `Parameters`
/// Descriptions
/// - Parameters:    random
///   - foo: foo's description
///   - bar: bar's description
func f5(foo: Int, bar: Int) {}
