import DrString
import SourceKittenFramework

let module = Module(spmName: "DrString")
for doc in module?.docs ?? [] {
    let documentables = parseTopLevel(doc)
    for d in documentables {
        let problems = try validate(d)
        print(problems)
    }
}
