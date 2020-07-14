import Crawler
import Dispatch
import Editor
import IsTTY
import Pathos

#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif
import Foundation

enum FormatError: Error, LocalizedError {
    case missingInput

    var errorDescription: String? {
        switch self {
        case .missingInput:
            return "Paths to source files are missing. Please provide some."
        }
    }
}

public func formatEdits(fromSource source: String, path: String? = nil, with config: Configuration) throws -> [Edit] {
    var edits = [Edit]()
    let documentables = try extractDocs(fromSource: source, sourcePath: path)
    for documentable in documentables.compactMap({ $0 }) {
        edits += documentable.format(
            columnLimit: config.columnLimit,
            verticalAlign: config.verticalAlignParameterDescription,
            alignAfterColon: config.alignAfterColon,
            firstLetterUpperCase: config.firstKeywordLetter == .uppercase,
            parameterStyle: config.parameterStyle,
            separations: config.separatedSections,
            ignoreThrows: config.ignoreDocstringForThrows,
            ignoreReturns: config.ignoreDocstringForReturns,
            addPlaceholder: config.addPlaceholder,
            startLine: config.startLine,
            endLine: config.endLine)
    }

    return edits
}

public func format(with config: Configuration) throws {
    if config.includedPaths.isEmpty {
        throw FormatError.missingInput
    }

    let startTime = getTime()
    var editCount = 0
    var fileCount = 0

    let included = Set((try? config.includedPaths.flatMap(glob)) ?? [])
    let excluded = Set((try? config.excludedPaths.flatMap(glob)) ?? [])

    let group = DispatchGroup()
    let queue = DispatchQueue.global()
    for path in included.subtracting(excluded) {
        group.enter()
        queue.async {
            do {
                let source = try readString(atPath: path)
                let edits = try formatEdits(fromSource: source, path: path, with: config)

                if !edits.isEmpty {
                    var editedLines = [String]()
                    let originalLines = source.split(separator: "\n", omittingEmptySubsequences: false)
                        .map(String.init)
                    var lastPosition = 0
                    for edit in edits {
                        editedLines += originalLines[lastPosition ..< edit.startingLine]
                        lastPosition = edit.endingLine
                        editedLines += edit.text
                    }

                    editedLines += originalLines[lastPosition...]

                    let finalText = editedLines.joined(separator: "\n")
                    try write(finalText, atPath: path)
                    editCount += edits.count
                }
            } catch let error {
                fatalError(String(describing: error) + path)
            }

            group.leave()
        }

        fileCount += 1
    }

    group.wait()
    let elapsedTime = readableDiff(from: startTime, to: getTime())
    if editCount > 0 {
        let summary: String
        if IsTerminal.standardOutput {
            summary = "Fixed \(String(editCount), color: .red) docstring\(editCount > 1 ? "s" : "") in \(String(fileCount), color: .blue) file\(fileCount > 1 ? "s" : "") in \(elapsedTime, color: .blue)\n"
        } else {
            summary = "Fixed \(editCount) docstring\(editCount > 1 ? "s" : "") in \(fileCount) file\(fileCount > 1 ? "s" : "") in \(elapsedTime)\n"
        }

        fputs(summary, stderr)
    }
}
