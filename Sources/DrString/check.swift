import DrCrawler
import DrCritic
import DrInformant
import IsTTY

public let checkCommand = Command(
    name: "check",
    shortDescription: "Check problems for existing doc strings")
{ config in
    let ignoreThrows = config.options.ignoreDocstringForThrows
    do {
        for path in config.paths {
            for documentable in try extractDocs(fromSourcePath: path)
                .compactMap({ $0 })
            {
                for problem in try validate(documentable, ignoreThrows: ignoreThrows) {
                    if IsTTY.standardOutput {
                        print(ttyText(for: problem))
                    } else {
                        print(plainText(for: problem))
                    }
                }
            }
        }

    } catch {}
}
