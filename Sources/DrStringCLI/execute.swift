#if canImport(Darwin)
import var Darwin.C.EXIT_FAILURE
import var Darwin.C.EXIT_SUCCESS
#else
import var Glibc.EXIT_FAILURE
import var Glibc.EXIT_SUCCESS
#endif
import DrString
import TSCBasic

func printHelp(_ stream: OutputByteStream) {
    kArgParser.printUsage(on: stream)
}

func printVersion() {
    print(version)
}

func execute(_ command: Command) -> Int32 {
    switch command {
    case .check(let configFile, let config):
        switch check(with: config, configFile: configFile) {
        case .ok:
            return EXIT_SUCCESS
        case .foundProblems:
            return EXIT_FAILURE
        case .missingInput:
            printHelp(stderrStream)
            return EXIT_FAILURE
        }
    case .format(let config):
        format(with: config)
        return EXIT_SUCCESS

    case .explain(let problemIDs):
        return explain(problemIDs) ?? EXIT_SUCCESS
    case .help:
        printHelp(stdoutStream)
        return EXIT_SUCCESS
    case .version:
        printVersion()
        return EXIT_SUCCESS
    }
}
