import DrString
import Guaka

private let longMessage = """
Explains problems reported by the `check` command.

`check` reports each problem with an ID that looks like `E002`. This command
takes these IDs as input and prints out an explaination for each given ID.

You can specify multiple IDs as arguments.

IDs doesn't have to be fully spelled out. Alternative to `E002`, all of the
following are equivalent: `E2`, `e2`, `002`, `2`.
"""

private let example = """
Let's say you want to read out about E002, E011, and E005. All of the following
are equivalent:

  drstring explain E002 E011 E005

  drstring e E2 E11 E5

  drstring why 2 11 5
"""

let explainCommand: Guaka.Command = {
    var command = Guaka.Command(
        usage: "explain [Problem ID]...",
        shortMessage: "Explain a problem associated with an ID",
        longMessage: longMessage,
        example: example,
        aliases: ["e", "why", "what"])
    { _, arguments in
        if let code = explain(arguments) {
            exit(code)
        }
    }

    command.preRun = { _, arguments in
        if arguments.count < 1 {
            print(command.helpMessage)
            return false
        }

        return true
    }
    return command
}()
