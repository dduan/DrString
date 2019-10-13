import Crawler
import Critic
import Informant
import IsTTY

#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif
import Dispatch

public enum CheckResult {
    case ok
    case foundProblems
    case missingInput
}

public func check(with config: Configuration) -> CheckResult {
    if config.includedPaths.isEmpty {
        fputs("[check] Paths to source files are missing. Please provide some.\n", stderr)
        return .missingInput
    }

    let startTime = getTime()
    var problemCount = 0
    var fileCount = 0
    let ignoreThrows = config.ignoreDocstringForThrows
    let format = config.outputFormat
    let firstLetterUpper: Bool

    switch config.firstKeywordLetter {
    case .lowercase:
        firstLetterUpper = false
    case .uppercase:
        firstLetterUpper = true
    }

    let group = DispatchGroup()
    let queue = DispatchQueue.global()
    for path in config.paths {
        group.enter()
        queue.async {
            do {
                for documentable in try extractDocs(fromSourcePath: path).compactMap({ $0 }) {
                    if let problem = try validate(documentable, ignoreThrows: ignoreThrows, firstLetterUpper: firstLetterUpper, needsSeparation: config.separatedSections, verticalAlign: config.verticalAlignParameterDescription) {
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
            } catch {}
            group.leave()
        }
        fileCount += 1
    }

    group.wait()
    let elapsedTime = readableDiff(from: startTime, to: getTime())

    if problemCount > 0 {
        let summary: String
        if IsTerminal.standardError {
            summary = "Found \(String(problemCount), color: .red) problem\(problemCount > 1 ? "s" : "") in \(String(fileCount), color: .blue) file\(fileCount > 1 ? "s" : "") in \(elapsedTime, color: .blue)\n"
        } else {
            summary = "Found \(problemCount) problem\(problemCount > 1 ? "s" : "") in \(fileCount) file\(problemCount > 1 ? "s" : "") in \(elapsedTime)\n"
        }

        fputs(summary, stderr)
        return .foundProblems
    } else {
        return .ok
    }
}
