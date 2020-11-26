extension Configuration {
    mutating func extend(with options: SharedCommandLineOptions) {
        self.extend(with: options.basics)
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

    mutating func extend(with basicOptions: SharedCommandLineBasicOptions) {
        if !basicOptions.include.isEmpty {
            self.includedPaths = basicOptions.include
        }

        if !basicOptions.exclude.isEmpty {
            self.excludedPaths = basicOptions.exclude
        }

        if basicOptions.noExclude {
            self.excludedPaths = []
        }
    }
}


extension Configuration {
    mutating func extend(with checkCommand: Check) {
        self.extend(with: checkCommand.options)
        self.outputFormat = checkCommand.format ?? self.outputFormat
        self.allowSuperfluousExclusion = checkCommand.superfluousExclusion ?? self.allowSuperfluousExclusion
        self.allowEmptyPatterns = checkCommand.emptyPatterns ?? self.allowEmptyPatterns
    }
}


extension Configuration {
    mutating func extend(with formatCommand: Format) {
        self.extend(with: formatCommand.options)
        self.columnLimit = formatCommand.columnLimit ?? self.columnLimit
        self.addPlaceholder = formatCommand.addPlaceholder ?? self.addPlaceholder
        self.startLine = formatCommand.startLine ?? self.startLine
        self.endLine = formatCommand.endLine ?? self.endLine
    }
}
