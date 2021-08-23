## main

## 0.5.1

Upgrade Swift version to 5.4

## 0.5.0

### New

- `drstring check` now reports each problem it finds with a file path, line, and column, as apposed to before,
  where all problems for a specific signature are grouped together. Each type of problem has a custom column
  position to best indicate which part of the docstring it relates to.
- `drstring extract`'s output for existing docstrings gained a new field `relativeLineNumber` for each
  "entry".

### Bug fixes
- In grouped parameter style, spacing between the dash `-` and the parameter was not checked before. From this
  release on, any spacing except a single space is deemed problematic. (#225)
- If documentation for throws and returns starts on the second line, previously this was considered
  problematic. But it's pretty common to start on the next line. This bug has been fixed. (#213)

## 0.4.3

- Introduce a new subcommand: `extract`. It outputs existing docsting, and the signature associated
  with it, in JSON format.

## 0.4.2

### New

- A boolean option `empty-patterns` that allows empty path patterns to exist in include/exclude list.
- CLI auto-complete scripts for Bash and Zsh.

## 0.4.1

### Improvements

- Parameter entries mistakenly start with `- Parameters` is now parsed as entries, whereas before they were
  treated as multi-parameter headers, and their descriptions get dropped as a consequence.
- When a config file is invalid TOML, and its location is inferred, DrString now properly reports this.
  Previously it just complains as if there isn't any configuration (missing input).
- Updated dependencies which brings some fixes for bugs that lead to crash in edge cases.
- Fixed a bug where paths caused by exclusion pattern is seen as "explicitly" excluded.

### Changes

- The `version` subcommand is replaced by a flag on the main command. So `drstring --version` instead of
  `drstring version`.


## 0.4.0

### Changes

- Supports Swift 5.2 syntax, which also means the project requires 5.2 to build.
- For boolean options, instead of specifying negative value with `false` following the flag on the command
  line, a new corresponding negative flag should be used. For example, previously, not ignoring docstring
  section for `throws` can be specified by `--ignore-throws false`. Now it should be `--no-ignore-throws`.
  The help texts for all boolean commands have been updated to reflect this.

### New

- Similar to boolean options, now there's negative flags to override repeatable values on the command line.
  Example: `--no-needs-separation` will negate any `needs-separation` values.


## 0.3.6

### New

- Patterns used as part of inclusion/exclusion list may not match any files in the file system. This is now
  detected and reported as a problem.

### Improved

- The count of issues is now accurate no matter how many issues were found.

## 0.3.5

### New

- Ability to generate placeholder documentation for parameters, returns, throws as needed. The option is
  `add-placeholder` and works in conjunction with `ignore-throws` and `ignore-returns`.
- `start-line` and `end-line` are options that, together, specifies a range of lines for the `format`
  subcommand to consider. Any docstring for functions covered in this range will be formatted, and those
  outside of this range won't be.

### Improved

- If a path to config file is not specified, in addition to looking at `./.drstring.toml`, DrString will look
  for a `.drstring.toml` from either the current working directory or directory of a included path for
  checking/formatting from command line. It'll keep looking in the parent directory until a `.drstring.toml`
  is found or root directory is encountered.

## 0.3.4

### Improved

- Fixed bug #149, in which continued line with no prefix whitespace and content were incorrectly included in
  consideration for vertical alignment.
- Fixed bug #148, in which superfluously excluded files in config file is reported to have been excluded from
  command line arguments.

## 0.3.3

### Improved

- Options from command-line arguments now compliments those from a configuration file. Previously a valid
  configuration cause options from command-line to be completely ignored. Now, the command-line options take
  precedence over config file.

- Fixed bug #140, where `throws` for `init`s were ignored when extracting code signature.

- Fixed a bug where small amount of missing spaces prefixing continuation lines in docstring entries are not
  reported as a problem when vertical alignment is required (#144)

### New

- Docstring entries that does not contain a `:` in their header (for example, `- parameter:`) were previously
  thrown out as invalid. They now are recogonized as entries and DrString will complain about and fix the
  missing colon character.

## 0.3.2

### Improved

- Fixed bug #127, where docstring item with empty content is incorrectly formatted.

## 0.3.1

### Changes

- The commandline interface has been re-implemented in a new framework. Notable changes include
  - subcommands no longer have aliases
  - command line options no longer have short names, except for `-i` and `-x`.
  - `help` and `version` are now subcommands
  - help message layout changes
  - running without subcommand no longer runs the `check` subcommand

### Improved

- Improved problem description when it's not related to a particular part of code. For example, when a file is
  superfically excluded (#90).
- The project now vendors one library with multiple targets as opposed to multiple libraries, one for each
  target.

### New

- `init`s are now treated the same as functions. Prior to this release, they were ignored.

## 0.3.0

### New

- New subcommand `format` automatically fixes whitespace errors in docstrings according to options specified
  via command line options or config file.
- The option `ignore-returns` that makes presence of `returns` docstring non-mandatory.
  (similar to `ignore-throws`)
- The option `parameter-style` enables linting against mixed parameter organizations. "separate" and "grouped"
  styles can be enfored by using respective values for this option. The value `whatever` disables checks for
  this element.
- The option `align-after-colon` enables enforcement of starting colomn of descriptions for parameters,
  returns and throws. For each of these sections, if the setting is set, all lines of descriptions must begin
  after the `:` characeter from the first line.
- The path to config file can now be specified via the `--config-file` command line option. The default path
  is `.drstring.toml`.
- The `format` option gained a new value `paths`, which causes `drstring check` to print out only paths to
  problematic files, and not the rest of the problems details.

## 0.2.2

### New

- Paths (not including glob patterns) in the `exclude` option will be deemed superfluous when the `check`
  command can't find any docstring problems or when it's not to be checked in the first place. This behavior
  can be turned off by `superfluous-exclusion=true`.

### Improved

- If a function does throw, and a `throws` entry exists, whitespace problems will be detected regardless of
  value of `ignore-throw`.

## 0.2.1

### Changes

- Option for first keyword letter in config file in previous releases were `first-keyword-letter`.
  Now it's `first-letter`, similar to command line argument for the option.

## 0.2.0

### New

- Add problem IDs for each problem identified by `check`
- Add subcommand `explain` for problem ID explaining
- Support configuration via TOML file
- Add a lot more documentation both in CLI and repo
- Add many new rules/options for linting

## 0.1.0

### New

- Add subcommand `check`, which is the original command from 0.0.1
- Add help messages for main command and `check`
- Support option `--ignore-throws`, which makes DrString ignore throws in docstring validation.
- Colored output for TTY
- Support option `--format`, which controls the output format.
- Add support for TOML config files

## 0.0.1

For SwiftPM projects, find existing docstring for function, report issues in these docstrings.
