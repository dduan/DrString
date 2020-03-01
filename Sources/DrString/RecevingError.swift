import Foundation

enum ConfigFileError: Error, LocalizedError {
    case configFileDoesNotExist(String)
    case configFileIsInvalid(String)

    var errorDescription: String? {
        switch self {
        case .configFileDoesNotExist(let path):
            return "Could not find configuration file '\(path)'."
        case .configFileIsInvalid(let path):
            return "File '\(path)' doesn't contain valid configuration for DrString."
        }
    }
}
