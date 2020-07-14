public enum Command {
    case check(configFile: String?, config: Configuration)
    case format(Configuration)
    case explain([String])

    var config: Configuration? {
        switch self {
        case .check(_, let config):
            return config
        case .format(let config):
            return config
        case .explain:
            return nil
        }
    }
}
