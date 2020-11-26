import Crawler
import Critic
import Informant
import IsTTY
import Pathos
import Models
import Decipher
#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif
import Dispatch
import Foundation

struct Documented: Codable {
    let documentable: Documentable
    let docstring: DocString
}

public func extract(with config: Configuration) throws {
    if config.includedPaths.isEmpty {
        throw CheckError.missingInput
    }

    let serialQueue = DispatchQueue(label: "ca.duan.DrString.serial")
    var hasOutput = false
    let group = DispatchGroup()
    let queue = DispatchQueue(label: "ca.duan.DrString.concurrent", attributes: .concurrent)

    let (included, _) = expandGlob(patterns: config.includedPaths)
    let (excluded, _) = expandGlob(patterns: config.excludedPaths)

    print("[", terminator: "")
    for path in included {
        let isPathExcluded = excluded.contains(path)
        guard !(isPathExcluded && config.allowSuperfluousExclusion) else {
            continue
        }

        queue.async(group: group) {
            do {
                let (documentables, _) = try extractDocs(fromSourcePath: path)
                for documentable in documentables.compactMap({ $0 }) {
                    if !documentable.docLines.isEmpty, let docstring = try? parse(lines: documentable.docLines) {
                        let documented = Documented(documentable: documentable, docstring: docstring)
                        if let json = try? JSONEncoder().encode(documented), let jsonString = String(data: json, encoding: .utf8) {
                            serialQueue.async {
                                if hasOutput {
                                    print(",")
                                } else {
                                    hasOutput = true
                                }

                                print(jsonString)
                            }
                        }
                    }
                }
            } catch {}
        }

    }

    group.wait()
    print("]", terminator: "")
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
