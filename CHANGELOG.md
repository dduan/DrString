## master

### New

- The option `ignore-returns` that makes presence of `returns` docstring non-mandatory.
  (similar to `ignore-throws`)
- The option `parameter-style` enables linting against mixed parameter organizations. "separate" and "grouped"
  styles can be enfored by using respective values for this option. The value `whatever` disables checks for
  this element.
- The option `align-after-colon` enables enforcement of starting colomn of descriptions for parameters,
  returns and throws. For each of these sections, if the setting is set, all lines of descriptions must begin
  after the `:` characeter from the first line.


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
