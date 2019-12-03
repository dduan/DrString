import DrString
import Pathos
import TOMLDecoder
import TSCUtility

private let kDefaultConfigurationPath = ".drstring.toml"
extension Command {
    enum ReceivingError: Error {
        case configFileDoesNotExist(String)
        case configFileIsInvalid(String)
    }

    init(arguments: [String]) throws {
        let (parser, binder) = (kArgParser, kArgBinder)
        let result = try parser.parse(arguments)

        var command = Command.help
        try binder.fill(parseResult: result, into: &command)

        let configPath = command.configFile ?? kDefaultConfigurationPath
        let explicitPath = command.configFile != nil

        if explicitPath && (try? isA(.file, atPath: configPath)) != .some(true) {
            throw ReceivingError.configFileDoesNotExist(configPath)
        }

        command.configFile = configPath

        if let configText = try? readString(atPath: configPath),
            let decoded = try? TOMLDecoder().decode(Configuration.self, from: configText)
        {
            command.config = decoded
        } else if explicitPath {
            throw ReceivingError.configFileIsInvalid(configPath)
        }

        self = command
    }
}
