import DrCrawler
import DrCritic
import DrInformant
import IsTTY

public let checkCommand = Command(
    name: "check",
    shortDescription: "Check problems for existing doc strings")
{ config in
    let ignoreThrows = config.options.ignoreDocstringForThrows
    let format = config.options.outputFormat
    do {
        for path in config.paths {
            for documentable in try extractDocs(fromSourcePath: path)
                .compactMap({ $0 })
            {
                for problem in try validate(documentable, ignoreThrows: ignoreThrows) {
                    let output: String
                    switch (format, IsTerminal.standardOutput) {
                    case (.automatic, true), (.terminal, _):
                        output = ttyText(for: problem)
                    case (.automatic, false), (.plain, _):
                        output = plainText(for: problem)
                    }

                    print(output)
                }
            }
        }

    } catch {}
}
