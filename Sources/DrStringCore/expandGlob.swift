import Pathos

func expandGlob(patterns: [Path]) -> (Set<Path>, Set<Path>) {
    var valid = Set<Path>()
    var invalid = Set<Path>()
    for pattern in patterns {
        let expanded = (try? pattern.glob()) ?? []
        if expanded.isEmpty {
            invalid.insert(pattern)
        } else {
            valid.formUnion(expanded)
        }
    }

    return (valid, invalid)
}
