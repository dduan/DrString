import DrCrawler
import DrCritic
import Foundation
import SourceKittenFramework

let kHelp = """
Usage: \(CommandLine.arguments[0]) SWIFTPM_MODUL_ENAME
"""
guard CommandLine.argc > 1, case let moduleName = CommandLine.arguments[1] else {
    print(kHelp)
    exit(0)
}

let module = Module(spmName: moduleName)
for doc in module?.docs ?? [] {
    let documentables = parseTopLevel(doc)
    for d in documentables {
        for problem in  try validate(d) {
            print(problem)
            print("")
        }
    }
}
