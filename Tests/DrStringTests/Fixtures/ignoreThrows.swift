struct Test1 {
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
}
