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

public func format(with config: Configuration) {
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
                var edits = [Edit]()
                let (documentables, source) = try extractDocs(fromSourcePath: path)
                for documentable in documentables.compactMap({ $0 }) {
                    edits += documentable.format(
                        columnLimit: config.columnLimit,
                        verticalAlign: config.verticalAlignParameterDescription,
                        alignAfterColon: config.alignAfterColon,
                        firstLetterUpperCase: config.firstKeywordLetter == .uppercase,
                        parameterStyle: config.parameterStyle,
                        separations: config.separatedSections)
                }

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
