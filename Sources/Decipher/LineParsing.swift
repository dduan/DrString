import Models

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
        line[remainderStart...].starts(with: rest),
        case let wordEnd = line.index(remainderStart, offsetBy: rest.count)
        else
    {
        return nil
    }

    let headEnd = line[wordEnd...].firstIndex(where: { !$0.isLetter }) ?? line.endIndex

    return (
        line[dashPositionNext ..< headStart],
        line[headStart ..< headEnd],
        line[headEnd...]
    )
}

// ` - Parameters:`
func parseGroupedParametersHeader(fromLine line: String) throws -> (String, TextLeadByWhitespace, String, Bool, TextLeadByWhitespace)? {
    return try descriptionAfterDash(line: line, firstLetter: "p", rest: "arameters")
}

private func splitNameColonDescription(fromLine postDash: String.SubSequence) -> (String, String, String, Bool, String, String)? {
    guard let nameStart = postDash.firstIndex(where: { !$0.isWhitespace }),
        let nameEnd = postDash[nameStart...].firstIndex(where: { $0.isWhitespace || $0 == ":" })
        else
    {
        return nil
    }

    let colonPosition: String.Index
    let hasColon: Bool

    if let maybeColonPosition = postDash.firstIndex(where: { $0 == ":" }), nameEnd <= maybeColonPosition {
        colonPosition = maybeColonPosition
        hasColon = true
    } else {
        colonPosition = nameEnd
        hasColon = false
    }

    let postColonPosition = hasColon ? postDash.index(after: colonPosition) : nameEnd
    let postColon = postDash[postColonPosition...]
    let descriptionStart = postColon.firstIndex(where: { !$0.isWhitespace }) ?? postColon.endIndex
    return (
        String(postDash[..<nameStart]),
        String(postDash[nameStart ..< nameEnd]),
        String(postDash[nameEnd ..< colonPosition]),
        hasColon,
        String(postDash[postColonPosition ..< descriptionStart]),
        String(postColon[descriptionStart...])
    )
}

/// Parses a line like `/// - someParam: description of it`, and returns
///   * leading whitespaces of `-`
///   * leading whitespaces and name of the parameter
///   * leading whitespaces of `:`
///   * leading whitespaces and the description on this line
func parseGroupedParameter(fromLine line: String) throws -> (String, TextLeadByWhitespace, String, Bool, TextLeadByWhitespace)? {
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
    guard let (preName, name, preColon, hasColon, preDesc, desc) = splitNameColonDescription(fromLine: postDash) else {
        return nil
    }

    return (String(preDashSpace), TextLeadByWhitespace(preName, name), preColon, hasColon, TextLeadByWhitespace(preDesc, desc))
}

/// Parses a line like `/// - parameter someParam: description of it`, and returns
///   * leading whitespaces of `-`
///   * leading whitespaces and the word that counts as `parameter`
///   * leading whitespaces and name of the parameter
///   * leading whitespaces of `:`
///   * leading whitespaces and the description on this line
func parseParameter(fromLine line: String) throws -> (String, TextLeadByWhitespace, TextLeadByWhitespace, String, Bool, TextLeadByWhitespace)? {
    let (preDash, line) = try trimDocHead(fromLine: line)
    guard
        let (preParam, param, postDash) = try trimDash(fromLine: line, firstLetter: "p", rest: "arameter")
        else
    {
        return nil
    }

    guard let (preName, name, preColon, hasColon, preDesc, desc) = splitNameColonDescription(fromLine: postDash) else {
        return nil
    }

    return (
        String(preDash),
        TextLeadByWhitespace(String(preParam), String(param)),
        TextLeadByWhitespace(preName, name),
        preColon,
        hasColon,
        TextLeadByWhitespace(preDesc, desc)
    )
}

/// parse ` - keyword: description`
private func descriptionAfterDash(line: String, firstLetter: Character, rest: String) throws -> (String, TextLeadByWhitespace, String, Bool, TextLeadByWhitespace)? {
    guard
        case let (preDash, postDash) = try trimDocHead(fromLine: line),
        let (preKeyword, keyword, colonRest) = try trimDash(fromLine: postDash, firstLetter: firstLetter, rest: rest)
        else
    {
        return nil
    }

    let colonPosition: String.Index
    let hasColon: Bool

    if let maybeColonIndex = colonRest.firstIndex(where: { $0 == ":" }) {
        colonPosition = maybeColonIndex
        hasColon = true
    } else {
        colonPosition = colonRest.startIndex
        hasColon = false
    }

    let postColonPosition = hasColon ? colonRest.index(after: colonPosition) : colonPosition
    let postColon = colonRest[postColonPosition...]
    let descriptionStart = postColon.firstIndex(where: { !$0.isWhitespace }) ?? postColon.endIndex
    return (
        String(preDash),
        TextLeadByWhitespace(String(preKeyword), String(keyword)),
        String(colonRest[..<colonPosition]),
        hasColon,
        TextLeadByWhitespace(String(postColon[postColonPosition ..< descriptionStart]), String(postColon[descriptionStart...]))
    )
}

func parseReturns(fromLine line: String) throws -> (String, TextLeadByWhitespace, String, Bool, TextLeadByWhitespace)? {
    return try descriptionAfterDash(line: line, firstLetter: "r", rest: "eturn")
}

func parseThrows(fromLine line: String) throws -> (String, TextLeadByWhitespace, String, Bool, TextLeadByWhitespace)? {
    return try descriptionAfterDash(line: line, firstLetter: "t", rest: "hrow")
}

func parse(line: String) throws -> Parsing.LineResult {
    if let (preDash, keyword, preColon, hasColon, description) = try parseGroupedParametersHeader(fromLine: line) {
        return .groupedParametersHeader(preDash, keyword, preColon, hasColon, description)
    } else if let (preDash, keyword, preColon, hasColon, description) = try parseReturns(fromLine: line) {
        return .returns(preDash, keyword, preColon, hasColon, description)
    } else if let (preDash, keyword, preColon, hasColon, description) = try parseThrows(fromLine: line) {
        return .throws(preDash, keyword, preColon, hasColon, description)
    } else if let (preDash, keyword, name, preColon, hasColon, description) = try parseParameter(fromLine: line) {
        return .parameter(preDash, keyword, name, preColon, hasColon, description)
    } else if let (preDash, keyword, preColon, hasColon, description) = try parseGroupedParameter(fromLine: line) {
        return .groupedParameter(preDash, keyword, preColon, hasColon, description)
    }

    return .words(try parseWords(fromLine: line))
}
