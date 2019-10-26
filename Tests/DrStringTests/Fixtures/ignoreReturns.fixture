enum IgnoreReturnsFixture {
    // CHECK-NOT: Missing docstring for return type `String`
    /// Test0 doc
    func test0() -> String { fatalError() }

    // CHECK: `returns` should start with exactly 1 space before `-`
    // CHECK: For `returns`, there should be exactly 1 space after `:`
    /// Description
    ///
    /// - parameter t1i0: t1i0 description
    ///- returns:          description of returns
    func test1(_ t1i0: Int) -> String { fatalError() }
}
