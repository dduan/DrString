#if canImport(Darwin)
import func Darwin.exit
#else
import func Glibc.exit
#endif

exit(run(arguments: Array(CommandLine.arguments.dropFirst())))
