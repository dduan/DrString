 private enum UnwrapError: Error {
     case missingValue
 }

 /// Unwrap the optional value produced by the closure, or throw. This is useful when the value is required to
 /// exist, but you don't want to force unwrap to let the tests continue. Mark your XCTest as throws to make
 /// the test case automatically handle exceptions
 ///
 /// - parameter expression: an expression that produces the optional value to unwrap
 ///
 /// - throws UnwrapError.missingValue: This is private so it can't be caught in the test
 ///
 /// - returns: The unwrapped value
 public func XCTUnwrap<T>(_ expression: @autoclosure () throws -> T?) throws -> T {
     if let value = try expression() {
         return value
     } else {
         throw UnwrapError.missingValue
     }
 }
