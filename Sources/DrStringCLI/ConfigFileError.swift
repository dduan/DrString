import Foundation

enum ConfigFileError: Error, LocalizedError {
    case configFileDoesNotExist(String)
    case configFileIsInvalid(path: String, underlyingError: Error)

    var errorDescription: String? {
        switch self {
        case .configFileDoesNotExist(let path):
            return "Could not find configuration file '\(path)'."
        case .configFileIsInvalid(let path, let error):
            return "File '\(path)' doesn't contain valid configuration for DrString. Underlying error: \(error)"
        }
    }
}
