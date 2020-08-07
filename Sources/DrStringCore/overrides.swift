extension Configuration {
    mutating func extend(with options: SharedCommandLineOptions) {
        if !options.include.isEmpty {
            self.includedPaths = options.include
        }

        if !options.exclude.isEmpty {
            self.excludedPaths = options.exclude
        }

        if options.noExclude {
            self.excludedPaths = []
        }

        self.ignoreDocstringForThrows = options.ignoreThrows ?? self.ignoreDocstringForThrows
        self.ignoreDocstringForReturns = options.ignoreReturns ?? self.ignoreDocstringForReturns
        self.verticalAlignParameterDescription = options.verticalAlign ?? self.verticalAlignParameterDescription
        self.firstKeywordLetter = options.firstLetter ?? self.firstKeywordLetter

        if !options.needsSeparation.isEmpty {
            self.separatedSections = options.needsSeparation
        }

        if options.noNeedsSeparation {
            self.separatedSections = []
        }

        if !options.alignAfterColon.isEmpty {
            self.alignAfterColon = options.alignAfterColon
        }

        if options.noAlignAfterColon {
            self.alignAfterColon = []
        }
    }
}


extension Configuration {
    mutating func extend(with checkCommand: Check) {
        self.outputFormat = checkCommand.format ?? self.outputFormat
        self.allowSuperfluousExclusion = checkCommand.superfluousExclusion ?? self.allowSuperfluousExclusion
        self.allowEmptyPatterns = checkCommand.emptyPatterns ?? self.allowEmptyPatterns
    }
}


extension Configuration {
    mutating func extend(with formatCommand: Format) {
        self.columnLimit = formatCommand.columnLimit ?? self.columnLimit
        self.addPlaceholder = formatCommand.addPlaceholder ?? self.addPlaceholder
        self.startLine = formatCommand.startLine ?? self.startLine
        self.endLine = formatCommand.endLine ?? self.endLine
    }
}
