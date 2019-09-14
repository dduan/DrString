import DrDecipher

extension DocString {
    static var empty: DocString {
        return DocString(description: [], parameters: [], returns: [], throws: [])
    }
}
