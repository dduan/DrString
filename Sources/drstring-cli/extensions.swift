import DrString
import Guaka
extension DrString.Configuration.Options {
    init(_ flags: Flags) {
        self.init(ignoreDocstringForThrows: flags.getBool(name: Constants.ignoreThrows) ?? false)
    }
}

extension DrString.Configuration {
    init(_ flags: Flags) {
        self.init(
            includedPaths: flags[valuesForName: Constants.include] as? [String] ?? [],
            excludedPaths: flags[valuesForName: Constants.exclude] as? [String] ?? [],
            options: Options(flags))
    }
}

extension Guaka.Command {
    convenience init(_ command: DrString.Command, flags: [Flag]) {
        self.init(usage: command.name, shortMessage: command.shortDescription, flags: flags) { flags, _ in
            command.run(DrString.Configuration(flags))
        }
    }
}
