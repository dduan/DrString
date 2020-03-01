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
import Foundation

func report(_ problem: DocProblem, format: Configuration.OutputFormat) {
    let output: String
    switch (format, IsTerminal.standardOutput) {
    case (.paths, _):
        output = problem.filePath
    case (.automatic, true), (.terminal, _):
        output = ttyText(for: problem) + "\n"
    case (.automatic, false), (.plain, _):
        output = plainText(for: problem) + "\n"
    }

    print(output)
}

enum CheckError: Error, LocalizedError {
    case missingInput
    case foundProblems(String)

    var errorDescription: String? {
        switch self {
        case .missingInput:
            return "Paths to source files are missing. Please provide some."
        case .foundProblems(let summary):
            return summary
        }
    }
}

public func check(with config: Configuration, configFile: String?) throws {
    if config.includedPaths.isEmpty {
        throw CheckError.missingInput
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
    let queue = DispatchQueue(label: "ca.duan.DrString.concurrent", attributes: .concurrent)
    let serialQueue = DispatchQueue(label: "ca.duan.DrString.serial")
    let (included, invalidInclude) = expandGlob(patterns: config.includedPaths)
    let (excluded, invalidExclude) = expandGlob(patterns: config.excludedPaths)

    let allInvalidPatterns = invalidInclude.map { ($0, "inclusion") }
        + invalidExclude.map { ($0, "exclusion") }

    for (pattern, description) in allInvalidPatterns {
        report(
            .init(
                docName: pattern,
                filePath: pattern,
                line: 0,
                column: 0,
                details: [.invalidPattern(description, configFile)]),
            format: config.outputFormat
        )
    }

    problemCount += allInvalidPatterns.count

    for path in included {
        let isPathExcluded = excluded.contains(path)
        guard !(isPathExcluded && config.allowSuperfluousExclusion) else {
            continue
        }

        queue.async(group: group) {
            do {
                var foundProblems = false
                let (documentables, _) = try extractDocs(fromSourcePath: path)
                for documentable in documentables.compactMap({ $0 }) {
                    if let problem = try documentable.validate(
                        ignoreThrows: ignoreThrows,
                        ignoreReturns: ignoreReturns,
                        firstLetterUpper: firstLetterUpper,
                        needsSeparation: config.separatedSections,
                        verticalAlign: config.verticalAlignParameterDescription,
                        parameterStyle: config.parameterStyle,
                        alignAfterColon: config.alignAfterColon)
                    {
                        foundProblems = true
                        if !isPathExcluded {
                            serialQueue.async {
                                problemCount += problem.details.count
                            }
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
                            details: [.excludedYetNoProblemIsFound(configFile)]
                        ),
                        format: config.outputFormat
                    )

                    serialQueue.async {
                        problemCount += 1
                    }
                }
            } catch {}
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

            serialQueue.async {
                problemCount += 1
            }
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

        throw CheckError.foundProblems(summary)
    }
}

private func expandGlob(patterns: [String]) -> (Set<String>, Set<String>) {
    var valid = Set<String>()
    var invalid = Set<String>()
    for pattern in patterns {
        let expanded = (try? Pathos.glob(pattern)) ?? []
        if expanded.isEmpty {
            invalid.insert(pattern)
        } else {
            valid.formUnion(expanded)
        }
    }

    return (valid, invalid)
}
