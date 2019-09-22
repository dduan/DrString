import DrCrawler
import DrCritic
import DrInformant
import IsTTY

#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif

public let checkCommand = Command(
    name: "check",
    shortDescription: "Check problems for existing doc strings")
{ config in
    var problemCount = 0
    var fileCount = 0
    let ignoreThrows = config.options.ignoreDocstringForThrows
    let format = config.options.outputFormat
    for path in config.paths {
        do {
            for documentable in try extractDocs(fromSourcePath: path).compactMap({ $0 }) {
                fileCount += 1
                for problem in try validate(documentable, ignoreThrows: ignoreThrows) {
                    problemCount += 1
                    let output: String
                    switch (format, IsTerminal.standardOutput) {
                    case (.automatic, true), (.terminal, _):
                        output = ttyText(for: problem)
                    case (.automatic, false), (.plain, _):
                        output = plainText(for: problem)
                    }

                    fputs("\(output)\n\n", stderr)
                }
            }
        } catch let error {
        }
    }

    if problemCount > 0 {
        fputs("Found \(problemCount) problem\(problemCount > 1 ? "s" : "") in \(fileCount) file\(problemCount > 1 ? "s" : "").", stderr)
        exit(-1)
    }
}
