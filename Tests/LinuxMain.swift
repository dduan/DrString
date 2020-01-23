import XCTest

import CriticTests
import DecipherTests
import DrStringTests
import EditorTests
import ModelsTests

var tests = [XCTestCaseEntry]()
tests += CriticTests.__allTests()
tests += DecipherTests.__allTests()
tests += DrStringTests.__allTests()
tests += EditorTests.__allTests()
tests += ModelsTests.__allTests()

XCTMain(tests)
