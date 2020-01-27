@testable import DrString
import Pathos
import XCTest

final class CLITests: XCTestCase {
    private let directory: String = { "/" + #file.split(separator: "/").dropLast().joined(separator: "/") }()

    func testConfigFileOptionsAreProperlyParsedForCheckSubcommand() throws {
        let configFilePath = join(paths: self.directory, "Fixtures", "config0.toml")
        let command = try Command(arguments: ["check", "--config-file", configFilePath])
        XCTAssertEqual(command.config?.firstKeywordLetter, .lowercase)
        XCTAssertEqual(command.config?.separatedSections, [.description])
    }

    func testCommandLineArgumentOverridesConfigFileOptionForCheckSubcommand() throws {
        let configFilePath = join(paths: self.directory, "Fixtures", "config0.toml")
        let command = try Command(arguments: ["check", "--config-file", configFilePath, "--first-letter", "uppercase"])
        XCTAssertEqual(command.config?.firstKeywordLetter, .uppercase)
        XCTAssertEqual(command.config?.separatedSections, [.description])
    }

    func testConfigFileOptionsAreProperlyParsedForFormatSubcommand() throws {
        let configFilePath = join(paths: self.directory, "Fixtures", "config0.toml")
        let command = try Command(arguments: ["format", "--config-file", configFilePath])
        XCTAssertEqual(command.config?.firstKeywordLetter, .lowercase)
        XCTAssertEqual(command.config?.separatedSections, [.description])
    }

    func testCommandLineArgumentOverridesConfigFileOptionForFormatSubcommand() throws {
        let configFilePath = join(paths: self.directory, "Fixtures", "config0.toml")
        let command = try Command(arguments: ["format", "--config-file", configFilePath, "--first-letter", "uppercase"])
        XCTAssertEqual(command.config?.firstKeywordLetter, .uppercase)
        XCTAssertEqual(command.config?.separatedSections, [.description])
    }

    func testStartLineIsProperlyParsed() throws {
        let line = 42
        let command = try Command(arguments: ["format", "--start-line", "\(line)", "-i", "a"])
        XCTAssertEqual(command.config?.startLine, .some(line))
    }

    func testEndLineIsProperlyParsed() throws {
        let line = 42
        let command = try Command(arguments: ["format", "--end-line", "\(line)", "-i", "a"])
        XCTAssertEqual(command.config?.endLine, .some(line))
    }
}
