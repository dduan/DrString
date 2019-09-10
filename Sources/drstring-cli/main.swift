import DrCrawler
import DrCritic
import SourceKittenFramework

let module = Module(spmName: "drstring_cli")
for doc in module?.docs ?? [] {
    let documentables = parseTopLevel(doc)
    for d in documentables {
        for problem in  try validate(d) {
            print(problem)
            print("")
        }
    }
}
