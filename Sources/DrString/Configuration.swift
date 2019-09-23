import Pathos

public struct Configuration: Decodable {
    let includedPaths: [String]
    let excludedPaths: [String]
    let options: Options

    var paths: [String] {
        let included = Set((try? self.includedPaths.flatMap(glob)) ?? [])
        let excluded = Set((try? self.excludedPaths.flatMap(glob)) ?? [])
        return Array(included.subtracting(excluded)).sorted()
    }

    public init(includedPaths: [String], excludedPaths: [String], options: Options) {
        self.includedPaths = includedPaths
        self.excludedPaths = excludedPaths
        self.options = options
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.includedPaths = try values.decode([String].self, forKey: .include)
        self.excludedPaths = try values.decodeIfPresent([String].self, forKey: .exclude) ?? []
        self.options = try values.decodeIfPresent(Options.self, forKey: .options) ??
            Options(
                ignoreDocstringForThrows: false,
                verticalAlignParameterDescription: false,
                outputFormat: .automatic
            )
    }

    enum CodingKeys: String, CodingKey {
        case include
        case exclude
        case options
    }

    public enum OutputFormat: String, Equatable, Decodable {
        case automatic = "automatic"
        case terminal = "terminal"
        case plain = "plain"
    }

    public struct Options: Decodable {
        let ignoreDocstringForThrows: Bool
        let verticalAlignParameterDescription: Bool
        let outputFormat: OutputFormat

        public init(ignoreDocstringForThrows: Bool, verticalAlignParameterDescription: Bool, outputFormat: OutputFormat) {
            self.ignoreDocstringForThrows = ignoreDocstringForThrows
            self.verticalAlignParameterDescription = verticalAlignParameterDescription
            self.outputFormat = outputFormat
        }

        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.ignoreDocstringForThrows = try values.decodeIfPresent(Bool.self, forKey: .ignoreThrows) ?? false
            self.verticalAlignParameterDescription = try values.decodeIfPresent(Bool.self, forKey: .verticalAlign) ?? false
            self.outputFormat = try values.decodeIfPresent(OutputFormat.self, forKey: .format) ?? .automatic
        }

        enum CodingKeys: String, CodingKey {
            case ignoreThrows = "ignore-throws"
            case verticalAlign = "vertical-align"
            case format = "format"
        }
    }
}
