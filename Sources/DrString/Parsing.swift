import SWXMLHash
import SourceKittenFramework

func parseFunction(_ structure: SourceKitRepresentable, context: FunctionSignature.Context) -> FunctionSignature? {
    let dict = structure as? Dictionary<String, SourceKitRepresentable> ?? [:]
    guard dict["key.kind"] as? String ?? "" == context.declKind.rawValue,
        let xmlDecl = dict["key.fully_annotated_decl"] as? String else
    {
        return nil
    }

    return FunctionSignature(fullyAnnotatedXML: xmlDecl, context: context)
}

public func parseTopLevel(_ doc: SwiftDocs) -> [FunctionSignature] {
    let structures = doc.docsDictionary[SwiftDocKey.substructure.rawValue] as? [SourceKitRepresentable] ?? []
    var result = [FunctionSignature]()
    for structure in structures {
        if let function = parseFunction(structure, context: .free) {
            result.append(function)
        }

        result += parseClass(structure)
        result += parseEnum(structure)
        result += parseStruct(structure)
        result += parseProtocol(structure)
    }

    return result
}

func parseClass(_ structure: SourceKitRepresentable) -> [FunctionSignature] {
    let dict = structure as? Dictionary<String, SourceKitRepresentable> ?? [:]
    guard dict["key.kind"] as? String ?? "" == SwiftDeclarationKind.class.rawValue else {
        return []
    }
    return parseNestable(dict, nest: true)
}

func parseStruct(_ structure: SourceKitRepresentable) -> [FunctionSignature] {
    let dict = structure as? Dictionary<String, SourceKitRepresentable> ?? [:]
    guard dict["key.kind"] as? String ?? "" == SwiftDeclarationKind.struct.rawValue else {
        return []
    }
    return parseNestable(dict, nest: true)
}

func parseProtocol(_ structure: SourceKitRepresentable) -> [FunctionSignature] {
    let dict = structure as? Dictionary<String, SourceKitRepresentable> ?? [:]
    guard dict["key.kind"] as? String ?? "" == SwiftDeclarationKind.protocol.rawValue else {
        return []
    }
    return parseNestable(dict, nest: false)
}

func parseEnum(_ structure: SourceKitRepresentable) -> [FunctionSignature] {
    let dict = structure as? Dictionary<String, SourceKitRepresentable> ?? [:]
    guard dict["key.kind"] as? String ?? "" == SwiftDeclarationKind.enum.rawValue else {
        return []
    }
    return parseNestable(dict, nest: true)
}

func parseNestable(_ dict: Dictionary<String, SourceKitRepresentable>, nest: Bool) -> [FunctionSignature] {
    let structures = dict[SwiftDocKey.substructure.rawValue] as? [SourceKitRepresentable] ?? []
    var result = [FunctionSignature]()
    for structure in structures {
        if let function = parseFunction(structure, context: .staticMethod) {
            result.append(function)
        }

        if let function = parseFunction(structure, context: .instance) {
            result.append(function)
        }

        if nest {
            result += parseClass(structure)
            result += parseEnum(structure)
            result += parseStruct(structure)
        }
    }

    return result
}
