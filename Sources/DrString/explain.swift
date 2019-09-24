import Critic
#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif

public let explainCommand = Command(
    name: "explain",
    shortDescription: "Explain a problem associated with an ID")
{ config, arguments in
    var unrecognizedIDs = [String]()

    for id in arguments {
        // TODO: make ID look-up smarter. e1, e001, 1 or 001 should match to E001, for example.
        if let explainer = Explainer.all[id.uppercased()] {
            // TODO: print string
            // TODO: translate sections surrounded by `*` to bold
            // TODO: respect formatting preference from config
            print(explainer)
        } else {
            unrecognizedIDs.append(id)
        }
    }

    if !unrecognizedIDs.isEmpty {
        fputs("Unrecgonized IDs:   \(unrecognizedIDs.joined(separator: ", ")) \n", stderr)
        fputs("Please choose from: \(Explainer.all.keys.sorted().joined(separator: ", "))", stderr)
        return 1
    }

    return nil
}
