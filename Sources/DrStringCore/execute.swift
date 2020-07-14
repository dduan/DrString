public func execute(_ command: Command) throws {
    switch command {
    case .check(let configFile, let config):
        try check(with: config, configFile: configFile)
    case .format(let config):
        try format(with: config)
    case .explain(let problemIDs):
        try explain(problemIDs)
    }
}
