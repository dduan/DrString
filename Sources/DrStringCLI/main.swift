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

var mainCommand: Guaka.Command = {
let command = Guaka.Command(
    usage: "drstring",
    longMessage: longMessage,
    example: example)

    command.run = { flags, arguments in
        check(flags: flags, arguments: arguments, help: command.helpMessage)
    }

    return command
}()

mainCommand.add(subCommand: checkCommand)
mainCommand.add(subCommand: explainCommand)
mainCommand.execute()
