enum GroupedParameterStyle {
    // CHECK: Parameters are organized in the "separate" style, but "grouped" style is preferred
    /// Description
    ///
    /// - Parameter foo: foo description
    /// - Parameter bar: bar description
    func f(foo: Int, bar: Int) {}

    // CHECK-NOT: Parameters are organized in the "separete" style, but "grouped" style is preferred
    /// Description
    /// - Parameters:
    ///   - foo: foo description
    ///   - bar: bar description
    func g(foo: Int, bar: Int) {}
}
