import Critic
import Pathos

public typealias Section = Critic.Section
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
                firstKeywordLetter: .uppercase,
                outputFormat: .automatic,
                separatedSections: []
            )
    }

    enum CodingKeys: String, CodingKey {
        case include
        case exclude
        case options
    }

    public enum OutputFormat: String, Equatable, Decodable {
        case automatic
        case terminal
        case plain
    }

    public enum FirstKeywordLetterCasing: String, Equatable, Decodable {
        case uppercase
        case lowercase
    }

    public struct Options: Decodable {
        let ignoreDocstringForThrows: Bool
        let verticalAlignParameterDescription: Bool
        let firstKeywordLetter: FirstKeywordLetterCasing
        let outputFormat: OutputFormat
        let separatedSections: [Section]

        public init(
            ignoreDocstringForThrows: Bool,
            verticalAlignParameterDescription: Bool,
            firstKeywordLetter: FirstKeywordLetterCasing,
            outputFormat: OutputFormat,
            separatedSections: [Section])
        {
            self.ignoreDocstringForThrows = ignoreDocstringForThrows
            self.verticalAlignParameterDescription = verticalAlignParameterDescription
            self.firstKeywordLetter = firstKeywordLetter
            self.outputFormat = outputFormat
            self.separatedSections = separatedSections
        }

        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            self.ignoreDocstringForThrows = try values.decodeIfPresent(Bool.self, forKey: .ignoreThrows) ?? false
            self.verticalAlignParameterDescription = try values.decodeIfPresent(Bool.self, forKey: .verticalAlign) ?? false
            self.firstKeywordLetter = try values.decodeIfPresent(FirstKeywordLetterCasing.self, forKey: .firstKeyordLetter) ?? .uppercase
            self.outputFormat = try values.decodeIfPresent(OutputFormat.self, forKey: .format) ?? .automatic
            self.separatedSections = try values.decodeIfPresent([Section].self, forKey: .separations) ?? []
        }

        enum CodingKeys: String, CodingKey {
            case ignoreThrows = "ignore-throws"
            case verticalAlign = "vertical-align"
            case firstKeyordLetter = "first-keyword-letter"
            case format = "format"
            case separations = "needs-separation"
        }
    }
}
