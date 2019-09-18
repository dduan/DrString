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

private func trimDocHead(fromLine line: String) throws -> String.SubSequence {
    guard
        let docHeadEnd = line.endIndex(ofFirst: "///")
        else
    {
        throw Parsing.LineError.missingCommentHead(line)
    }

    let postDocHead = line[docHeadEnd...]
    let start = postDocHead.firstIndex(where: { !$0.isWhitespace }) ?? postDocHead.endIndex
    return postDocHead[start...]
}

func parseWords(fromLine line: String) throws -> String {
    return String(try trimDocHead(fromLine: line))
}

// trim number of spaces, "-", number of spaces, and a word whose first letter captilization is ignored
private func trimDash(fromLine line: String.SubSequence, firstLetter: Character, rest: String) throws -> String.SubSequence? {
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

    return line[line.index(remainderStart, offsetBy: rest.count)...]
}

func parseGroupedParametersHeader(fromLine line: String) throws -> String? {
    let line = try trimDocHead(fromLine: line)
    let valid = (try trimDash(fromLine: line, firstLetter: "p", rest: "arameters")) != nil
    return valid ? String(line) : nil
}

private func splitNameColonDescription(fromLine postDash: String.SubSequence) -> (String, String)? {
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
    let postColon = postDash[postDash.index(after: colonPosition)...]
    let descriptionStart = postColon.firstIndex(where: { !$0.isWhitespace }) ?? postColon.endIndex
    return (String(postDash[nameStart ..< nameEnd]), String(postColon[descriptionStart...]))
}

func parseGroupedParameter(fromLine line: String) throws -> (String, String)? {
    let line = try trimDocHead(fromLine: line)
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
    return splitNameColonDescription(fromLine: postDash)
}

func parseParameter(fromLine line: String) throws -> (String, String)? {
    guard
        let line = try trimDash(fromLine: trimDocHead(fromLine: line), firstLetter: "p", rest: "arameter")
        else
    {
        return nil
    }

    return splitNameColonDescription(fromLine: line)
}

private func descriptionAfterDash(line: String, firstLetter: Character, rest: String) throws -> String? {
    guard
        let line = try trimDash(fromLine: trimDocHead(fromLine: line), firstLetter: firstLetter, rest: rest),
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
        return .groupedParametersHeader(rawHeader)
    } else if let description = try parseReturns(fromLine: line) {
        return .returns(description)
    } else if let description = try parseThrows(fromLine: line) {
        return .throws(description)
    } else if let (name, description) = try parseParameter(fromLine: line) {
        return .parameter(name, description)
    } else if let (name, description) = try parseGroupedParameter(fromLine: line) {
        let rawText = try parseWords(fromLine: line)
        return .groupedParameter(name, description, rawText)
    }

    return .words(try parseWords(fromLine: line))
}
