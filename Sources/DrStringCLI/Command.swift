import DrString

enum Command {
    case check(configFile: String?, config: Configuration)
    case format(Configuration)
    case explain([String])
    case version
    case help

    var configFile: String? {
        get {
            switch self {
            case .check(let file, _):
                return file
            default:
                return nil
            }
        }

        set {
            switch self {
            case .check(_, let config):
                self = .check(configFile: newValue, config: config)
            default:
                return
            }
        }
    }

    var config: Configuration? {
        get {
            switch self {
            case .check(_, let config):
                return config
            case .format(let config):
                return config
            default:
                return nil
            }
        }

        set {
            switch (self, newValue) {
            case (.check(let file, _), .some(let config)):
                self = .check(configFile: file, config: config)
            case (.format, .some(let config)):
                self = .format(config)
            default:
                return
            }
        }
    }
}
