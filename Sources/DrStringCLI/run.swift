#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif

private func handle(_ error: Command.ReceivingError) -> Int32 {
    switch error {
    case .configFileDoesNotExist(let path):
        fputs("Config file doesn't exist at \(path).", stderr)
    case .configFileIsInvalid(let path):
        fputs("\(path) does not contain valid configuration.", stderr)
    }

    return EXIT_FAILURE
}

func run(arguments: [String]) -> Int32 {
    do {
        return try execute(Command(arguments: arguments))
    } catch let error as Command.ReceivingError {
        return handle(error)
    } catch let error {
        fputs("\(error)", stderr)
        return EXIT_FAILURE
    }
}
