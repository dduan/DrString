import DrCrawler
import DrCritic

public let checkCommand = Command(
    name: "check",
    shortDescription: "Check problems for existing doc strings")
{ config in
    do {
        for path in config.paths {
            for documentable in try extractDocs(fromSourcePath: path)
                .compactMap({ $0 })
            {
                for problem in try validate(documentable) {
                    print(problem)
                    print("")
                }
            }
        }

    } catch {}
}
