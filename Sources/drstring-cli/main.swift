import DrCrawler
import DrCritic
import Foundation

for filePath in CommandLine.arguments.dropFirst() {
    let documentables = try extractDocs(fromSourcePath: filePath)
    for documentable in documentables {
        for problem in try validate(documentable) {
            print(problem)
            print("")
        }
    }
}
