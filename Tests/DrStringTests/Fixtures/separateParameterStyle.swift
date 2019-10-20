enum SeparateParameterStyle {
    // CHECK-NOT: Parameters are organized in the "grouped" style, but "separate" style is preferred.
    /// Description
    ///
    /// - Parameter foo: foo description
    /// - Parameter bar: bar description
    func f(foo: Int, bar: Int) {}

    // CHECK: Parameters are organized in the "grouped" style, but "separate" style is preferred.
    /// Description
    /// - Parameters:
    ///   - foo: foo description
    ///   - bar: bar description
    func g(foo: Int, bar: Int) {}
}
