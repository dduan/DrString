public struct Configuration {
    public struct Options {
        let ignoreDocstringForThrows: Bool

        public init(ignoreDocstringForThrows: Bool) {
            self.ignoreDocstringForThrows = ignoreDocstringForThrows
        }
    }

    let includedPaths: [String]
    let excludedPaths: [String]
    let options: Options

    var paths: [String] {
        // TODO: globbing
        // TODO: compute by consolidating include/exclude
        return self.includedPaths
    }

    public init(includedPaths: [String], excludedPaths: [String], options: Options) {
        self.includedPaths = includedPaths
        self.excludedPaths = excludedPaths
        self.options = options
    }
}
