import Guaka
import DrString
import Pathos
import TOMLDecoder

enum ParsedOptions {
    case success(DrString.Configuration, configPath: String?)
    case configDecodeFailure(configPath: String)

    init(from flags: Flags, arguments: [String]) {
        let config: DrString.Configuration
        var path: String? = ".drstring.toml"
        if let path = path, (try? isA(.file, atPath: path)) == .some(true) {
            guard let configText = try? readString(atPath: path),
                let decoded = try? TOMLDecoder().decode(DrString.Configuration.self, from: configText) else
            {
                self = .configDecodeFailure(configPath: path)
                return
            }

            config = decoded
        } else {
            config = DrString.Configuration(flags)
            path = nil
        }

        self = .success(config, configPath: path)
    }
}
