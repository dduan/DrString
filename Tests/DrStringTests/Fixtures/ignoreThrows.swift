enum IgnoreThrowsFixture {
    // CHECK: 3 docstring problems
    // CHECK: Missing docstring for `t0i1` of type `Int`
    // CHECK: Unrecognized docstring for `random`
    // CHECK-NOT: Missing docstring for throws
    // CHECK: Missing docstring for return type `String`
    /// Test0 doc
    ///
    /// - parameter random: random
    /// - parameter t0i0: this is t0i0
    func test0(_ t0i0: String, lt0i1 t0i1: Int) throws -> String { fatalError() }

    // CHECK: `throws` should start with exactly 1 space before `-`
    // CHECK: For `throws`, there should be exactly 1 space after `:`
    /// Description
    ///
    /// - parameter t1i0: t1i0 description
    ///- throws:          description of throws
    func test1(_ t1i0: Int) throws {}
}
