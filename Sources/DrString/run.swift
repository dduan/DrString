import ArgumentParser
import Pathos
import TOMLDecoder
import Models

private func makeConfig(from options: SharedCommandLineOptions) throws -> (String?, Configuration) {
    var config = Configuration()
    let explicitPath: String? = options.configFile
    if let explicitPath = explicitPath, (try? isA(.file, atPath: explicitPath)) != .some(true) {
        throw ConfigFileError.configFileDoesNotExist(explicitPath)
    }

    let exampleInput = options.include.first { !$0.contains("*") }
    let configPath = explicitPath ?? seekConfigFile(forPath: exampleInput ?? ".")
    var configPathResult: String?
    config.extend(with: options)

    do {
        let configText = try readString(atPath: configPath)
        let decoded = try TOMLDecoder().decode(Configuration.self, from: configText)
        config = decoded
        configPathResult = configPath
        config.extend(with: options)
        return (configPathResult, config)
    } catch let error {
        throw ConfigFileError.configFileIsInvalid(path: configPath, underlyingError: error)
    }
}

private let kDefaultConfigurationPath = ".drstring.toml"
private func seekConfigFile(forPath path: String) -> String {
    guard var dir = try? absolutePath(ofPath: path) else {
        return kDefaultConfigurationPath
    }

    while dir != "/" {
        dir = directory(ofPath: dir)
        if case let path = join(paths: dir, kDefaultConfigurationPath),
            (try? isA(.file, atPath: path)) == .some(true)
        {
            return path
        }
    }

    return kDefaultConfigurationPath
}

extension Command {
    init?(command: ParsableCommand) throws {
        switch command {
        case let command as Check:
            var (configPath, config) = try makeConfig(from: command.options)
            config.extend(with: command)
            self = .check(configFile: configPath, config: config)
        case let command as Format:
            var (_, config) = try makeConfig(from: command.options)
            config.extend(with: command)
            self = .format(config)
        case let command as Explain:
            self = .explain(command.problemID)
        default:
            return nil
        }
    }
}

public func run(arguments: [String]) {
    do {
        let parsedCommand = try Main.parseAsRoot(arguments)
        if let command = try Command(command: parsedCommand) {
            try execute(command)
        } else {
            try parsedCommand.run()
        }
    } catch let error {
        Main.exit(withError: error)
    }
}
