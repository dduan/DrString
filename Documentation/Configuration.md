# DrString Configuration Options

Docstrings can differ in many subtle ways based on preference of a codebase.
DrString offers options to define your preferences.

*The [overview](Overview.md) talks more about these subtleties.*

## How to read this guide

Each option is usable both as a key/value in the configuration file, and one or
more command line arguments. As a command line argument, the options as listed 
are the long/full name of the argument. So "include" would be used as
`--include`, for example. In config files, they are keys for [TOML][] tables.

Besides a general description that states purpose of the option, a few common
aspects are included:

- **Required**: Whether the option must be present for the command.
- **Repeatable**: Whether the option is a list of values. As command line
  arguments, being repeatable means the option can be specified one ore more
  times: `drstring check -i a.swift -i b.swift`. In a config file, a repeatable
  option is a TOML list.
- **Value**: The type or candidate of valid values for this option. A type
  ("String", "Bool") follows Unix command line arguments conventions. For
  example: `drstring check -i "path/to/a.swift" --ignore-throws true`. The
  String value could be quoted or not (do quote if want to pass a glob pattern
  to drstring as opposed to your shell); a Bool value could also be written as
  `1`/`0` etc. In a config file, the types refers to TOML types. When an option
  is *repeatable*, this is the type for the elements in a TOML list in a config
  file. Some option's value can only be one of several strings. For these,
  the list of valid values are listed instead of a type.
- **Default**: A default value if none is explicitly specfied. Not applicable
  if the option is *required*.

## Options for all commands

This option controls output format for DrString. `terminal` directs DrString to
output ANSI colors to parts of the output to enhance its readability in terminal
(TTY) devices. `plain` disables ANSI color in output. `automatic` makes DrString
detect whether output device is a terminal and do the right thing.

### format

|            |                                  |
| ---------- | -------------------------------- |
|   Required | No                               |
| Repeatable | No                               |
|      Value | `automatic`, `terminal`, `plain` |
|    Default | `automatic`                      |

## Options for the `check` command

Each of the options for the `check` subcommand can be used as both a command
line argument as well as a key-value in the .drstring.toml configuration file. 

*Read [Getting Started](GettingStarted.md) to see examples of using these
options*

### include

Path to Swift files that need to be checked. Glob patterns can be used to
specify all files in a path or recursively in a path. For example:

- `Sources/ModuleA/*.swift`: all .swift files in path `Sources/ModulesA`
- `Sources/**/*.swift`: all .swift files in path `Sources`, recursively.

This is sometimes known as "globstar" patterns.

|            |        |
| ---------- | ------ |
|   Required | Yes    |
| Repeatable | Yes    |
|      Value | String |
|    Default | N/A    |

### exclude

Similar to _include_ except it substracts paths from the list of included files.

|            |        |
| ---------- | ------ |
|   Required | No     |
| Repeatable | Yes    |
|      Value | String |
|    Default | []     |

### ignore-throws

Whether to make documentation for throws mandatory. When this is true, missing
documentation for `throws` won't be considered problematic.

|            |       |
| ---------- | ----- |
|   Required | No    |
| Repeatable | No    |
|      Value | Bool  |
|    Default | false |

### first-letter

[Keywords][] in docstring may begin with a upper- or lowercase letter. This is
the option to specify which is preferred. The not-preferred casing will be
considered problematic.

[Keywords]: Overview.md#anatomy-of-a-docstring-in-swift

|            |                          |
| ---------- | ------------------------ |
|   Required | No                       |
| Repeatable | No                       |
|      Value | `uppercase`, `lowercase` |
|    Default | `uppercase`              |


### needs-separation

Some codebases may prefer an empty line between [sections][]. For example, an
empty docstring line between documentation for parameters and the following
section (`throws` or `returns`). This is the option that makes the separation
mandatory. Each section that could have a separating line can be configured
independently.

For example, `needs-separation = ["description"]` cause lack of an empty
docstring line after the overall description a problem.

[sections]: Overview.md#anatomy-of-a-docstring-in-swift

|            |                                       |
| ---------- | ------------------------------------- |
|   Required | No                                    |
| Repeatable | Yes                                   |
|      Value | `description`, `parameters`, `throws` |
|    Default | []                                    |

### vertical-align

When there are more than one parameters in a function signature, description for
each parameter may be required to all start on the same column. When this option
is turned on, parameter descriptions that aren't vertically aligned are
considered problematic.

|            |       |
| ---------- | ----- |
|   Required | No    |
| Repeatable | No    |
|      Value | Bool  |
|    Default | false |

### superfluous-exclusion

By default, a full path in the `exclude`d list may be deemed redundant,
therefore, problematic. This behavior can be turned off if
`superfluous-exclusion` is `true`.

An excluded path is _superfluous_ if one of the following set of criteria is
met:

1. It's not an glob pattern, and DrString can't find any docstring problems in
   the file.
1. It's not an glob pattern, and DrString is not supposed to check for problems
   there according to the `include`d option.

|            |       |
| ---------- | ----- |
|   Required | No    |
| Repeatable | No    |
|      Value | Bool  |
|    Default | false |


[TOML]: https://github.com/toml-lang/toml
