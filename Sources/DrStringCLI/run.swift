import ArgumentParser
import Pathos
import TOMLDecoder
import Models
import DrStringCore

private func configFromFile(_ configPath: Path) throws -> Configuration? {
    if let configText = try? configPath.readUTF8String() {
        do {
            let decoded = try TOMLDecoder().decode(Configuration.self, from: configText)
            return decoded
        } catch let error {
            throw ConfigFileError.configFileIsInvalid(path: String(describing: configPath), underlyingError: error)
        }
    }

    return nil
}

private func makeConfig(from basicOptions: SharedCommandLineBasicOptions) throws -> (String?, Configuration) {
    let explicitPath = basicOptions.configFile.map(Path.init)
    if let explicitPath = explicitPath,
        (try? explicitPath.metadata().fileType.isFile) != .some(true)
    {
        throw ConfigFileError.configFileDoesNotExist(String(describing: explicitPath))
    }

    let exampleInput = basicOptions.include.first { !$0.contains("*") }
    let configPath = explicitPath ?? seekConfigFile(for: Path(exampleInput ?? "."))
    var config = Configuration()
    var configPathResult: String?
    if let decoded = try configFromFile(configPath) {
        config = decoded
        configPathResult = String(describing: configPath)
    }

    return (configPathResult, config)
}

private let kDefaultConfigurationPath = Path(".drstring.toml")
private func seekConfigFile(for path: Path) -> Path {
    guard let dir = try? path.absolute() else {
        return kDefaultConfigurationPath
    }

    for parent in dir.parents {
        let path = parent + kDefaultConfigurationPath
        if (try? path.metadata().fileType.isFile) == .some(true) {
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
