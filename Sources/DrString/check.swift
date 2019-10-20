import Crawler
import Critic
import Informant
import IsTTY
import Pathos

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

func report(_ problem: DocProblem, format: Configuration.OutputFormat) {
    let output: String
    switch (format, IsTerminal.standardOutput) {
    case (.automatic, true), (.terminal, _):
        output = ttyText(for: problem)
    case (.automatic, false), (.plain, _):
        output = plainText(for: problem)
    }

    print("\(output)\n")
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
    let ignoreReturns = config.ignoreDocstringForReturns
    let firstLetterUpper: Bool

    switch config.firstKeywordLetter {
    case .lowercase:
        firstLetterUpper = false
    case .uppercase:
        firstLetterUpper = true
    }

    let group = DispatchGroup()
    let queue = DispatchQueue.global()
    let included = config.globbedIncludedPaths
    let excluded = config.globbedExcludedPaths
    for path in included {
        let isPathExcluded = excluded.contains(path)
        guard !(isPathExcluded && config.allowSuperfluousExclusion) else {
            continue
        }

        group.enter()
        queue.async {
            do {
                var foundProblems = false
                for documentable in try extractDocs(fromSourcePath: path).compactMap({ $0 }) {
                    if let problem = try validate(
                        documentable,
                        ignoreThrows: ignoreThrows,
                        ignoreReturns: ignoreReturns,
                        firstLetterUpper: firstLetterUpper,
                        needsSeparation: config.separatedSections,
                        verticalAlign: config.verticalAlignParameterDescription)
                    {
                        foundProblems = true
                        if !isPathExcluded {
                            problemCount += problem.details.count
                            report(problem, format: config.outputFormat)
                        }
                    }
                }

                if !foundProblems &&
                    !config.allowSuperfluousExclusion &&
                    config.excludedPaths.contains(path)
                {
                    report(
                        .init(
                            docName: "",
                            filePath: path,
                            line: 0,
                            column: 0,
                            details: [.excludedYetNoProblemIsFound]
                        ),
                        format: config.outputFormat
                    )
                    problemCount += 1
                }
            } catch {}
            group.leave()
        }

        fileCount += 1
    }

    group.wait()

    if !config.allowSuperfluousExclusion {
        for path in excluded.filter({ !$0.contains("*") && !included.contains($0) }) {
            report(
                .init(
                    docName: "",
                    filePath: path,
                    line: 0,
                    column: 0,
                    details: [.excludedYetNotIncluded]
                    ),
                format: config.outputFormat
            )

            problemCount += 1
        }
    }

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

extension Configuration {
    var globbedIncludedPaths: Set<String> {
        Set((try? self.includedPaths.flatMap(glob)) ?? [])
    }

    var globbedExcludedPaths: Set<String> {
        Set((try? self.excludedPaths.flatMap(glob)) ?? [])
    }
}
