import Critic
import Informant

#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif

import Foundation

enum ExplainError: Error, LocalizedError {
    case unrecognizedID(String)

    var errorDescription: String? {
        switch self {
        case .unrecognizedID(let summary):
            return summary
        }
    }
}

public func explain(_ arguments: [String]) throws {
    var unrecognizedIDs = [String]()

    for id in arguments {
        if let explainer = Explainer.all[id.uppercased()] ?? guessID(id).flatMap({ Explainer.all[$0] }) {
            print(plainText(for: explainer))
        } else {
            unrecognizedIDs.append(id)
        }
    }

    if !unrecognizedIDs.isEmpty {
        throw ExplainError.unrecognizedID(
            "Unrecgonized ID\(unrecognizedIDs.count > 1 ? "s" : ""): \(unrecognizedIDs.joined(separator: ", ")). " +
            "Please choose from: \(Explainer.all.keys.sorted().joined(separator: ", "))"
        )
    }
}

private func guessID(_ badID: String) -> String? {
    let maybeNumber: String
    if badID.uppercased().first == "E" {
        maybeNumber = String(badID.dropFirst())
    } else {
        maybeNumber = badID
    }

    guard let n = Int(maybeNumber) else {
        return nil
    }

    if n < 10 {
        return "E00\(n)"
    } else if n < 100 {
        return "E0\(n)"
    } else {
        return "E\(n)"
    }
}
