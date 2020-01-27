import Pathos
import TOMLDecoder
import TSCUtility

private let kDefaultConfigurationPath = ".drstring.toml"

func seekConfigFile(forPath path: String) -> String {
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
    enum ReceivingError: Error {
        case configFileDoesNotExist(String)
        case configFileIsInvalid(String)
    }

    public init(arguments: [String]) throws {
        let (parser, binder) = (kArgParser, kArgBinder)
        let result = try parser.parse(arguments)

        var command = Command.help
        try binder.fill(parseResult: result, into: &command)

        let explicitPath: String? = try? result.get("--config-file")
        if let explicitPath = explicitPath, (try? isA(.file, atPath: explicitPath)) != .some(true) {
            throw ReceivingError.configFileDoesNotExist(explicitPath)
        }

        let exampleInput = command.config?.includedPaths.first { !$0.contains("*") }
        let configPath = explicitPath ?? seekConfigFile(forPath: exampleInput ?? ".")

        if let configText = try? readString(atPath: configPath),
            let decoded = try? TOMLDecoder().decode(Configuration.self, from: configText)
        {
            command.config = decoded
            // Override config with command line arguments
            try binder.fill(parseResult: result, into: &command)
            command.configFile = configPath
        } else if explicitPath != nil {
            throw ReceivingError.configFileIsInvalid(configPath)
        }

        self = command
    }
}
