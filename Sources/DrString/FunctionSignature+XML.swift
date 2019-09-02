import SWXMLHash

extension FunctionSignature {
    public init?(fullyAnnotatedXML xmlString: String?, context: Context) {
        guard let rootXML = xmlString.map(SWXMLHash.parse) else {
            return nil
        }

        self.init(functionXML: rootXML, context: context)
    }

    init?(functionXML: XMLIndexer, context: Context) {
        let xml = functionXML[String(context.declKind.rawValue.dropFirst(18))]
        guard let name = xml["decl.name"].element?.text else {
            return nil
        }
        self.name = name

        self.parameters = xml["decl.var.parameter"].all.compactMap(Parameter.init)
        self.throws = xml["syntaxtype.keyword"].all.contains { $0.element?.text == "throws" }
        self.returnType = xml["decl.function.returntype"].element?.recursiveText
    }
}

extension FunctionSignature.Parameter {
    init?(xml: XMLIndexer) {
        guard let nameElement = xml["decl.var.parameter.name"].element ??
            xml["decl.var.parameter.argument_label"].element,
            let type = xml["decl.var.parameter.type"].element?.recursiveText
            else
        {
            return nil
        }

        self.name = nameElement.text
        self.type = type
    }
}
