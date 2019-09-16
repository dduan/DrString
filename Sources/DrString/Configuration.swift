import Pathos

public struct Configuration {
    public enum OutputFormat: String, Equatable {
        case automatic = "automatic"
        case terminal = "terminal"
        case plain = "plain"
    }

    public struct Options {
        let ignoreDocstringForThrows: Bool
        let outputFormat: OutputFormat

        public init(ignoreDocstringForThrows: Bool, outputFormat: OutputFormat) {
            self.ignoreDocstringForThrows = ignoreDocstringForThrows
            self.outputFormat = outputFormat
        }
    }

    let includedPaths: [String]
    let excludedPaths: [String]
    let options: Options

    var paths: [String] {
        let included = Set((try? self.includedPaths.flatMap(glob)) ?? [])
        let excluded = Set((try? self.excludedPaths.flatMap(glob)) ?? [])
        return Array(included.subtracting(excluded)).sorted()
    }

    public init(includedPaths: [String], excludedPaths: [String], options: Options) {
        self.includedPaths = includedPaths
        self.excludedPaths = excludedPaths
        self.options = options
    }
}
