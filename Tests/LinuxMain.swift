import XCTest

import CriticTests
import DecipherTests
import DrStringCoreTests
import EditorTests
import ModelsTests

var tests = [XCTestCaseEntry]()
tests += CriticTests.__allTests()
tests += DecipherTests.__allTests()
tests += DrStringCoreTests.__allTests()
tests += EditorTests.__allTests()
tests += ModelsTests.__allTests()

XCTMain(tests)
