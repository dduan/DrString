# Getting Started with DrString

This tutorial teaches the basics of installing and using DrString.

Read [overview][] if you aren't sure about using DrString.

This tutorial assumes that you are comfortable with the command line. If not,
then read this introduction to the command line:

- [Learn Enough Command Line to Be Dangerous][cli]

[cli]: https://www.learnenough.com/command-line-tutorial

[overview]: Overview.md

## Install

### With Homebrew

```bash
brew install dduan/formulae/drstring
```

### With [Mint](https://github.com/yonaskolb/Mint)

```
mint install dduan/DrString
```

### Download from [release page](https://github.com/dduan/DrString/releases)

For macOS and Ubuntu Bionic/Focal, you can download a package from a release.
After unarchiving the package, the `drstring` binary should run without problems.
Make sure all content of the archive stay in the same relative location when you
move them. For example, if you move the executable to `FOO/bin/drstring`, the
content in `lib/*` should be in `FOO/lib`.

Note: if a parent process who calls `drstring` set the environment variable
`LD_LIBRARY_PATH` on Linux, it may affect its successful execution. You must
set `LD_LIBRARY_PATH` to the `lib` directory distributed with `drstring` in its
execution environment to restore its functionality.

## Usage

DrString is a CLI tool with subcommands. Some subcommands include many options
that customizes its behavior. These options can be expressed via either command
line arguments, or a configuration file.

### Checking for docstring problems

The `check` subcommand finds problems of existing docstrings:

```bash
drstring check -i 'Sources/**/*.swift'
```

In this example, all Swift files under `./Sources` will be examined recursively.
Paths is the only required option for the `check` command.

Another example:

```bash
drstring check \
    --include 'Sources/**/*.swift' \
    --include 'Tests/**/*.swift' \
    --exclude 'Tests/Fixtures/*.swift' \
    --ignore-throws \
    --first-letter uppercase
```

1. `--include` is the longer form of `-i`. Some options have a long form and
   a short form. This should be a familar Unix pattern.
2. You can exampt paths from being checked with `--exclude` (or `-e`).
3. `--include` and `--exclude` can repeat. In fact, this is true for all options
   that take a list of values.
4. `--ignore-throws` tells DrString documentation for `throws` is not required.
   `--first-letter` tells DrString to expect keywords in docstring such as
   `Parameter` should start with an uppercase letter. These are examples of
   options that customizes DrString's behavior. They exist to cater different
   style needs in different codebases.

There are many more [options][] for customizing DrString's behavior.

### Explainers

An output of the `check` command may look like this:

![](Assets/Demo.png)

You may have noticed some texts before each problem that reads like `|E008|`.
This is an ID for this category of problems. DrString has an `explain`
subcommand that takes the ID as argument:

```bash
drstring explain E008
```

In this example, DrString will proceed to print out an explanation of the
problem with examples that demonstrates the violation.


### Using a config file

Instead of specifying request with command line arguments, DrString can read
from a configuration file. The second example for `check` command can be
expressed in a configuration file as

```toml
include = [
    'Sources/**/*.swift',
    'Tests/**/*.swift',
]

exclude = [
    'Tests/Fixtures/*.swift',
]

ignore-throws = true
first-letter = "uppercase"
```

Save this file as `.drstring.toml` in the current worknig directory and simply
run `drstring` will cause DrString to do the exact same thing as the CLI
argument examlpe with `check` subcommand.

Different location for the config file can be specified as a command-line
argument via `--config-file`. For example:

```bash
drstring format --config-file PATH_TO_CONFIG_TOML
```

When the config file is not explicitly specified, but at least one file path is
present as a command-line argument, DrString will look for `.drstring.toml` in
its directory. If it's not there, then its parent directory… until the config
file is found, or root directory is encountered.

The configuration file is in [TOML][] format.

Options from command-line arguments overrides those found in config files.

[TOML]: https://github.com/toml-lang/toml

### Automatically fix whitespace errors

The `format` subcommand finds and fixes formatting errors in your docstrings.

```bash
drstring format -i 'Sources/**/*.swift'
```

It shares most [options][] with the `check` subcommand, which can be specified
as command-line arguments or via the config file.

[options]: Configuration.md

### Extract docstrings in JSON

Sometimes it's desirable to process existing docstring yourself. With the
`extract` subcommand, DrString output the signature and associated docstring
in JSON format, so that you can do whatever you like.

This subcommand uses the same information as `check`, and `format` to determine
the list of files to extract from.

### Integration with Xcode

Add a "Run Script" build phase in your project target:

```bash
if which drstring >/dev/null; then
  drstring check --config-file "$SRCROOT/.drstring.toml" || true
else
  echo "warning: DrString not installed. Run \
    `brew install dduan/formulae/drstring` or learn more at \
    https://github.com/dduan/DrString/blob/main/Documentation/GettingStarted.md#install"
fi
```

Note the second command should be however you would run drstring in command
line. `$SRCROOT` is a environment variable that mayb come in handy for locating
your config file.

There's a [Source editor extension][] that generates, and reformats comments in Xcode on
demand.

[Source editor extension]: https://apps.apple.com/us/app/drstring/id1523251484?mt=12

### Getting help

`-h` or `--help` is an option for all subcommands as well as the "root" command.
It's good for a quick reminder of what's available.

Read the [documentation for options][options] to learn more about ways to
enforec different docstring styles.

[options]: Configuration.md

### Tips and tricks

#### Explain faster

For the `explain`subcommand You can use partial IDs and DrString will try its
best to guess what you want to know. For example, instead of typing `E008`, `E8`
or `8` or `008` all get you the same result.

#### Starting off in a big codebase

In a big project, DrString might complain a lot at time of introduction. It's
totally reasonable to exclude files that contains these problems to begin with
(and slowly fix the problems, of course. How? I'll leave that as a reader
exercise…)

DrString has a `paths` format that outputs only paths to the problematic files:

```bash
drstring check --format paths
```

With some light processing, this can become the list of paths to exclude.

#### Running in CI

`drstring check` exits with status code 0 when no docstring problem is found,
and non-zero otherwise. Description of problems is printed to stdout and
a summary of problem ("found N problems in M files...") is printed in stderr.

This information should help you collect signal for failure, logs, etc.

#### Negative flags

On the command line, if `--x` means `true` for an option, `--no-x` can be used
for the corresponding `false` value.

### Shell Completion Script

DrString has a lot of CLI options! You may install one of the completion scripts
included in the project if one exists for your shell. You can find them
[here](../Scripts/completions).
