public enum Namespace: Equatable {
    case file(name: String, content: [Documentable])
    indirect case folder(name: String, children: [Namespace])
}
