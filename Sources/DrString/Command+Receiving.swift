import Pathos
import TOMLDecoder
import TSCUtility

private let kDefaultConfigurationPath = ".drstring.toml"
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
        let configPath = explicitPath ?? kDefaultConfigurationPath

        if explicitPath != nil && (try? isA(.file, atPath: configPath)) != .some(true) {
            throw ReceivingError.configFileDoesNotExist(configPath)
        }


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
