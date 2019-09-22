import Crawler
import Critic
import Informant
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
    var startTime = getTime()
    var problemCount = 0
    var fileCount = 0
    let ignoreThrows = config.options.ignoreDocstringForThrows
    let format = config.options.outputFormat
    for path in config.paths {
        do {
            for documentable in try extractDocs(fromSourcePath: path).compactMap({ $0 }) {
                fileCount += 1
                for problem in try validate(documentable, ignoreThrows: ignoreThrows) {
                    problemCount += problem.details.count
                    let output: String
                    switch (format, IsTerminal.standardOutput) {
                    case (.automatic, true), (.terminal, _):
                        output = ttyText(for: problem)
                    case (.automatic, false), (.plain, _):
                        output = plainText(for: problem)
                    }

                    print("\(output)\n")
                }
            }
        } catch let error {
        }
    }

    let elapsedTime = readableDiff(from: startTime, to: getTime())

    if problemCount > 0 {
        let summary: String
        if IsTerminal.standardError {
            summary = "Found \(String(problemCount), color: .red) problem\(problemCount > 1 ? "s" : "") in \(String(fileCount), color: .blue) file\(problemCount > 1 ? "s" : "") in \(elapsedTime, color: .blue)"
        } else {
            summary = "Found \(problemCount) problem\(problemCount > 1 ? "s" : "") in \(fileCount) file\(problemCount > 1 ? "s" : "") in \(elapsedTime)."
        }

        fputs(summary, stderr)
        return 1
    } else {
        return nil
    }
}
