import Guaka

#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif


private let longMessage = """
DrString \(version)

A Swift docstring linter, formatter, nitpicky assistant...

DrString helps you locate and fix docstring problems such as missing
documentation or whitespace errors. It help your team to write consistent
docstrings.

Learn more: https://github.com/dduan/DrString

"""

private let example = """
  Check every Swift source under ./Sources for problems:

    drstring check -i "Sources/**/*.swift"

  Explain the problem associated with ID `E007`

    drstring explain E007
"""

var mainCommand = Guaka.Command(
    usage: "drstring",
    longMessage: longMessage,
    example: example)

mainCommand.run = { flags, arguments in
    // TODO: this is wrong. Check returning non-success could mean it found problems. We want that to be the
    // overall status code, BUT, in that case we should not print help messages.
    if check(flags: flags, arguments: arguments) != EXIT_SUCCESS {
        fputs("\n\(mainCommand.helpMessage)", stderr)
    }
}

mainCommand.add(subCommand: checkCommand)
mainCommand.add(subCommand: explainCommand)
mainCommand.execute()
