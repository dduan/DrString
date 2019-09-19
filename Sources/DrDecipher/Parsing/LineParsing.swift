extension String {
    func endIndex(ofFirst other: String) -> String.Index? {
        guard
            let start = other.first.flatMap(self.firstIndex(of:)),
            case let end = self.index(start, offsetBy: other.count),
            end <= self.endIndex,
            zip(self[start...], other).allSatisfy(==)
            else
        {
            return nil
        }
        return end
    }
}

/// Trim '///'. Return proceeding leading whitespace, and the rest.
private func trimDocHead(fromLine line: String) throws -> (String.SubSequence, String.SubSequence) {
    guard
        let docHeadEnd = line.endIndex(ofFirst: "///")
        else
    {
        throw Parsing.LineError.missingCommentHead(line)
    }

    let postDocHead = line[docHeadEnd...]
    let startOfContent = postDocHead.firstIndex(where: { !$0.isWhitespace }) ?? postDocHead.endIndex
    return (postDocHead[..<startOfContent], postDocHead[startOfContent...])
}

func parseWords(fromLine line: String) throws -> TextLeadByWhitespace {
    let (lead, content) = try trimDocHead(fromLine: line)
    return TextLeadByWhitespace(String(lead), String(content))
}

// trim number of spaces, "-", number of spaces, and a word whose first letter captilization is ignored
// return the whitespace between dash and the word, the word, and rest of the line.
private func trimDash(fromLine line: String.SubSequence, firstLetter: Character, rest: String) throws
    -> (String.SubSequence, String.SubSequence, String.SubSequence)?
{
    let upper = String(firstLetter).uppercased().first!
    let lower = String(firstLetter).lowercased().first!

    guard
        let dashPosition = line.firstIndex(of: "-"),
        line[line.startIndex ..< dashPosition].allSatisfy({ $0.isWhitespace }),
        let headStart = line.firstIndex(where: { $0 == upper || $0 == lower }),
        case let dashPositionNext = line.index(after: dashPosition),
        dashPositionNext < line.endIndex,
        line[dashPositionNext ..< headStart].allSatisfy({ $0.isWhitespace }),
        case let remainderStart = line.index(after: headStart),
        remainderStart < line.endIndex,
        line[remainderStart...].starts(with: rest)
        else
    {
        return nil
    }

    let headEnd = line.index(remainderStart, offsetBy: rest.count)
    return (
        line[dashPositionNext ..< headStart],
        line[headStart ..< headEnd],
        line[headEnd...]
    )
}

func parseGroupedParametersHeader(fromLine line: String) throws -> (String, TextLeadByWhitespace)? {
    let (preDashLead, line) = try trimDocHead(fromLine: line)
    guard let (leadingSpace, word, rest) = (try trimDash(fromLine: line, firstLetter: "p", rest: "arameters")) else {
        return nil
    }

    return (String(preDashLead), TextLeadByWhitespace(String(leadingSpace), String(word + rest)))
}

private func splitNameColonDescription(fromLine postDash: String.SubSequence) -> (String, String, String, String, String)? {
    guard
        let nameStart = postDash.firstIndex(where: { !$0.isWhitespace }),
        let colonPosition = postDash.firstIndex(where: { $0 == ":" }),
        nameStart < colonPosition
        else
    {
        return nil
    }

    let untrimedName = postDash[nameStart ..< colonPosition]
    let nameEnd = untrimedName.firstIndex(where: { $0.isWhitespace }) ?? colonPosition
    let postColonPosition = postDash.index(after: colonPosition)
    let postColon = postDash[postColonPosition...]
    let descriptionStart = postColon.firstIndex(where: { !$0.isWhitespace }) ?? postColon.endIndex
    return (
        String(postDash[..<nameStart]),
        String(postDash[nameStart ..< nameEnd]),
        String(postDash[nameEnd ..< colonPosition]),
        String(postDash[postColonPosition ..< descriptionStart]),
        String(postColon[descriptionStart...])
    )
}

/// Parses a line like `/// - someParam: description of it`, and returns
///   * leading whitespaces of `-`
///   * leading whitespaces and name of the parameter
///   * leading whitespaces of `:`
///   * leading whitespaces and the description on this line
func parseGroupedParameter(fromLine line: String) throws -> (String, TextLeadByWhitespace, String, TextLeadByWhitespace)? {
    let (preDashSpace, line) = try trimDocHead(fromLine: line)
    guard
        let dashPosition = line.firstIndex(of: "-"),
        line[line.startIndex ..< dashPosition].allSatisfy({ $0.isWhitespace }),
        case let dashPositionNext = line.index(after: dashPosition),
        dashPositionNext < line.endIndex
        else
    {
        return nil
    }

    let postDash = line[dashPositionNext...]
    guard let (preName, name, preColon, preDesc, desc) = splitNameColonDescription(fromLine: postDash) else {
        return nil
    }

    return (String(preDashSpace), TextLeadByWhitespace(preName, name), preColon, TextLeadByWhitespace(preDesc, desc))
}

/// Parses a line like `/// - parameter someParam: description of it`, and returns
///   * leading whitespaces of `-`
///   * leading whitespaces and the word that counts as `parameter`
///   * leading whitespaces and name of the parameter
///   * leading whitespaces of `:`
///   * leading whitespaces and the description on this line
func parseParameter(fromLine line: String) throws -> (String, TextLeadByWhitespace, TextLeadByWhitespace, String, TextLeadByWhitespace)? {
    let (preDash, line) = try trimDocHead(fromLine: line)
    guard
        let (preParam, param, postDash) = try trimDash(fromLine: line, firstLetter: "p", rest: "arameter")
        else
    {
        return nil
    }

    guard let (preName, name, preColon, preDesc, desc) = splitNameColonDescription(fromLine: postDash) else {
        return nil
    }

    return (
        String(preDash),
        TextLeadByWhitespace(String(preParam), String(param)),
        TextLeadByWhitespace(preName, name),
        preColon,
        TextLeadByWhitespace(preDesc, desc)
    )
}

private func descriptionAfterDash(line: String, firstLetter: Character, rest: String) throws -> String? {
    guard
        let line = (try trimDash(fromLine: trimDocHead(fromLine: line).1, firstLetter: firstLetter, rest: rest))?.2,
        let colonPosition = line.firstIndex(where: { $0 == ":" })
        else
    {
        return nil
    }

    let postColon = line[line.index(after: colonPosition)...]
    let descriptionStart = postColon.firstIndex(where: { !$0.isWhitespace }) ?? postColon.endIndex
    return String(postColon[descriptionStart...])
}

func parseReturns(fromLine line: String) throws -> String? {
    return try descriptionAfterDash(line: line, firstLetter: "r", rest: "eturn")
}

func parseThrows(fromLine line: String) throws -> String? {
    return try descriptionAfterDash(line: line, firstLetter: "t", rest: "hrow")
}

func parseIndentation(fromLine line: String) throws -> String {
    guard
        let indentationEnd = line.firstIndex(where: { !$0.isWhitespace })
    else
    {
        throw Parsing.LineError.missingCommentHead(line)
    }

    return String(line[line.startIndex ..< indentationEnd])
}

func parse(line: String) throws -> Parsing.LineResult {
    if let rawHeader = try parseGroupedParametersHeader(fromLine: line) {
        return .groupedParametersHeader(rawHeader.1.text)
    } else if let description = try parseReturns(fromLine: line) {
        return .returns(description)
    } else if let description = try parseThrows(fromLine: line) {
        return .throws(description)
    } else if let (_, _, name, _, description) = try parseParameter(fromLine: line) {
        return .parameter(name.text, description.text)
    } else if let (_, name, _, description) = try parseGroupedParameter(fromLine: line) {
        let rawText = try parseWords(fromLine: line)
        return .groupedParameter(name.text, description.text, rawText.text)
    }

    return .words(try parseWords(fromLine: line).text)
}
