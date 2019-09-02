import DrString
import SourceKittenFramework

let module = Module(spmName: "DrString")

for doc in module?.docs ?? [] {
    for f in parseTopLevel(doc) {
        print(f)
    }
}
