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
  option is a TOML list. If a repeatable option is not required, a corresponding
  flag with prefix "--no-" can be used on the command line to override its
  otherwise specified value. For example, `--no-needs-separation` will make
  `needs-separation`'s value to be empty.
- **Value**: Valid values for this option. In a config file, the types refers to
  TOML types. When an option is *repeatable*, this is the type for the elements
  in a TOML list in a config file. Some option's value is a _enum_. For these,
  the list of valid values are listed instead of a type. Here's some notes on
  each value types:
  * enums: these should be given as strings, but only one of the listed value is
    valid. take `format`, for example, as command-line argument it should be
    written as `--format "plain"`.
  * Int: integer.
  * String: free form string. But its content should still make sense for its
    purpose (a file path, a pattern, etc).
  * Bool: In command-line, the option name alone signifies the "true" value. Add
    `no` in front of the command line flag for `false` value. For example,
    `--no-ignore-throws` is the `false` value for `ignore-throws`.
- **Default**: A default value if none is explicitly specified. Not applicable
  if the option is *required*.
- **Command**: The command(s) this option is effective for.

*Read [Getting Started](GettingStarted.md) to see examples of using these
options*

## The Options

### format

This option controls output format for DrString. `terminal` directs DrString to
output ANSI colors to parts of the output to enhance its readability in terminal
(TTY) devices. `plain` disables ANSI color in output. `automatic` makes DrString
detect whether output device is a terminal and do the right thing. `paths`
suppresses all details of output except paths to the source file. This is very
useful for getting a list of paths to exclude, for example.

|            |                                           |
| ---------- | ----------------------------------------- |
|   Required | No                                        |
| Repeatable | No                                        |
|      Value | `automatic`, `terminal`, `plain`, `paths` |
|    Default | `automatic`                               |
|    Command | check                                     |


### include

Path to Swift files that need to be checked. Glob patterns can be used to
specify all files in a path or recursively in a path. For example:

- `Sources/ModuleA/*.swift`: all .swift files in path `Sources/ModulesA`
- `Sources/**/*.swift`: all .swift files in path `Sources`, recursively.

This is sometimes known as "globstar" patterns.

|            |                        |
| ---------- | ---------------------- |
|   Required | Yes                    |
| Repeatable | Yes                    |
|      Value | String                 |
|    Default | N/A                    |
|    Command | check, format, extract |

### exclude

Similar to _include_ except it subtracts paths from the list of included files.

|            |                        |
| ---------- | ---------------------- |
|   Required | No                     |
| Repeatable | Yes                    |
|      Value | String                 |
|    Default | []                     |
|    Command | check, format, extract |

### ignore-throws

Whether to make documentation for `throws` mandatory. When this is `false`,
missing documentation for `throws` is considered problematic.

Note: if docstring for `throws` exists for a function that throws, its
whitespace error will be considered regardless of this option.

|            |               |
| ---------- | ------------- |
|   Required | No            |
| Repeatable | No            |
|      Value | Bool          |
|    Default | false         |
|    Command | check, format |

### ignore-returns

Whether to make documentation for `returns` mandatory. When this is `false`,
missing documentation for `returns` is considered problematic.

Note: if docstring for `returns` exists for a function that throws, its
whitespace error will be considered regardless of this option.

|            |               |
| ---------- | ------------- |
|   Required | No            |
| Repeatable | No            |
|      Value | Bool          |
|    Default | false         |
|    Command | check, format |

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
|    Command | check, format            |


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
|    Command | check, format                         |

### vertical-align

When there are more than one parameters in a function signature, description for
each parameter may be required to all start on the same column. When this option
is turned on, parameter descriptions that aren't vertically aligned are
considered problematic.

|            |               |
| ---------- | ------------- |
|   Required | No            |
| Repeatable | No            |
|      Value | Bool          |
|    Default | false         |
|    Command | check, format |

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
|    Command | check |

### empty-pattern

By default, a path pattern in the `included`/`exclude`d list may be deemed
redundant when it doesn't match any actual existing paths. These patterns are
problematic. This behavior can be turned off if `empty-patterns` is `true`.

|            |       |
| ---------- | ----- |
|   Required | No    |
| Repeatable | No    |
|      Value | Bool  |
|    Default | false |
|    Command | check |

### column-limit

Some codebases choose to limit the maximum length of a line in source files.
When this option is set, docstring lines that goes beyond the set column will be
broken down into multiple lines so that the result won't be over the limit.

If this option is not explicit set, there won't be any limit (put another way,
the limit is infinity).

|            |        |
| ---------- | ------ |
|   Required | No     |
| Repeatable | No     |
|      Value | Int    |
|    Default | nil    |
|    Command | format |

### parameter-style

As discussed in [overview][], there are two common format for organizing
docstrings for parameters. The _grouped_ format starts with a ` - Parameters:`
line. The _separate_ format does not. Examples:

```
/// This is the "grouped" format. Note how it has a "header" and individual
/// entries doesn't each begin with a `parameter` keyword.
///
/// - Parameters:
///   - foo: description for foo
///   - bar: description for bar
```

```
/// This is the "separate" format. Each parameter start with ` - Parameter`
/// entries doesn't each begin with a `parameter` keyword.
///
/// - Parameter foo: description for foo
/// - Parameter bar: description for bar
```

This option lets you specify which of the two styles, if any, is preferred.
Preferring one style makes the other one problematic.

|            |                                   |
| ---------- | --------------------------------- |
|   Required | No                                |
| Repeatable | No                                |
|      Value | `whatever`, `grouped`, `separate` |
|    Default | `whatever`                        |
|    Command | check, format                     |

### align-after-colon

For each itemized entry in a docstring (docs for a parameter/throws/returns),
each line of description should start at the same column, namely, 1 space after
the `:` character on the first line. For example:

```
/// - Returns: <- Start here. This is the first line
///            Second line starts here.
```
For parameters, the option `vertical-align` takes priority over this one.

This option is repeatable. Requirement for parameters, throws and returns can be
configured separately.

|            |                                   |
| ---------- | --------------------------------- |
|   Required | No                                |
| Repeatable | Yes                               |
|      Value | `parameters`, `returns`, `throws` |
|    Default | []                                |
|    Command | check, format                     |

### add-placeholder

|            |        |
| ---------- | ------ |
|   Required | No     |
| Repeatable | No     |
|      Value | Bool   |
|    Default | false  |
|    Command | format |

When formatting, generate placeholder entries for parameters, throws, and
returns, if necessary. `ignore-throws` and `ignore-returns` could cancel
generation for throws and returns, respectively.

### start-line

The earliest line to consider when formatting docstrings. This value has no
effect unless `end-line` is also present. If the line is in the range of
a function, the function is included for consideration.

|            |        |
| ---------- | ------ |
|   Required | No     |
| Repeatable | No     |
|      Value | Int    |
|    Default | nil    |
|    Command | format |

### end-line

The last line to consider when formatting docstrings. This value has no
effect unless `start-line` is also present. If the line is in the range of
a function, the function is included for consideration.

|            |        |
| ---------- | ------ |
|   Required | No     |
| Repeatable | No     |
|      Value | Int    |
|    Default | nil    |
|    Command | format |

[TOML]: https://github.com/toml-lang/toml
[overview]: Overview.md
