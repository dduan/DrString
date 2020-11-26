import ArgumentParser
import Pathos
import TOMLDecoder
import Models

private func configFromFile(_ configPath: String) throws -> Configuration? {
    if let configText = try? readString(atPath: configPath) {
        do {
            let decoded = try TOMLDecoder().decode(Configuration.self, from: configText)
            return decoded
        } catch let error {
            throw ConfigFileError.configFileIsInvalid(path: configPath, underlyingError: error)
        }
    }

    return nil
}

private func makeConfig(from basicOptions: SharedCommandLineBasicOptions) throws -> (String?, Configuration) {
    let explicitPath: String? = basicOptions.configFile
    if let explicitPath = explicitPath, (try? isA(.file, atPath: explicitPath)) != .some(true) {
        throw ConfigFileError.configFileDoesNotExist(explicitPath)
    }

    let exampleInput = basicOptions.include.first { !$0.contains("*") }
    let configPath = explicitPath ?? seekConfigFile(forPath: exampleInput ?? ".")
    var config = Configuration()
    var configPathResult: String?
    if let decoded = try configFromFile(configPath) {
        config = decoded
        configPathResult = configPath
    }

    return (configPathResult, config)
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
            var (configPath, config) = try makeConfig(from: command.options.basics)
            config.extend(with: command)
            self = .check(configFile: configPath, config: config)
        case let command as Format:
            var (_, config) = try makeConfig(from: command.options.basics)
            config.extend(with: command)
            self = .format(config)
        case let command as Explain:
            self = .explain(command.problemID)
        case let command as Extract:
            var (_, config) = try makeConfig(from: command.basics)
            config.extend(with: command.basics)
            self = .extract(config)
        default:
            return nil
        }
    }
}

public func run(arguments: [String]) {
    do {
        var parsedCommand = try Main.parseAsRoot(arguments)
        if let command = try Command(command: parsedCommand) {
            try execute(command)
        } else {
            try parsedCommand.run()
        }
    } catch let error {
        Main.exit(withError: error)
    }
}
