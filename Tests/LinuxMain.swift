import XCTest

import CriticTests
import DecipherTests
import DrStringTests

var tests = [XCTestCaseEntry]()
tests += CriticTests.__allTests()
tests += DecipherTests.__allTests()
tests += DrStringTests.__allTests()

XCTMain(tests)
