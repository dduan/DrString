func test0(_ t0i0: String, lt0i1 t0i1: Int, t0i2: UInt) throws -> String { fatalError() }

func test1(_ t1i0: String, lt1i1 t1i1: Int, t1i2: UInt) { fatalError() }

struct Test2 {
    /// Test3 doc
    func test3(_ t3i0: String, lt3i1 t0i1: Int, t3i2: UInt) { fatalError() }
}

enum Test4 {
    /// test5 doc
    func test5() {}
    /// test6 doc
    static func test6() {}

    struct Test7 {
        /// Test3 doc
        ///
        /// - parameter randomShit: random
        /// - parameter t8i0: this is t8i0
        func test8(_ t8i0: String, lt8i1 t0i1: Int, t8i2: UInt) { fatalError() }
    }
}

protocol Test9 {
    func test10(_ t8i0: String, lt8i1 t0i1: Int, t8i2: UInt) -> Int32
    static func test11()
}

class Test12 {
    func test13() {}
    static func test14() {}
    struct Test15 {
        func test16() {}
    }
}
