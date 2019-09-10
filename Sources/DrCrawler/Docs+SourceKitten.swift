import SourceKittenFramework

extension ExistingDocs {
    init?(_ dict: [String: SourceKitRepresentable]) {
        guard
            let name = dict[SwiftDocKey.docName.rawValue] as? String,
            let content = dict[SwiftDocKey.documentationComment.rawValue] as? String,
            let path = dict[SwiftDocKey.docFile.rawValue] as? String,
            let offset = dict[SwiftDocKey.offset.rawValue] as? Int64,
            let length = dict[SwiftDocKey.length.rawValue] as? Int64,
            let line = dict[SwiftDocKey.docLine.rawValue] as? Int64,
            let column = dict[SwiftDocKey.docColumn.rawValue] as? Int64
        else
        {
            return nil
        }

        self.name = name
        self.filePath = path
        self.content = content
        self.fileOffset = offset
        self.length = length
        self.line = line
        self.column = column
    }
}
