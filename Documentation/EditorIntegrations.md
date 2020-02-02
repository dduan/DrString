## Xcode

For linting, add a "Run Script" build phase in your project target:

```bash
if which drstring >/dev/null; then
  drstring check --config-file "$SRCROOT/.drstring.toml" || true
else
  echo "warning: DrString not installed. Run \
    `brew install dduan/formulae/drstring` or learn more at \
    https://github.com/dduan/DrString/blob/master/Documentation/GettingStarted.md#install"
fi
```

Note the second command should be however you would run drstring in command
line. `$SRCROOT` is a environment variable that mayb come in handy for locating
your config file.

## Vim/NeoVim

[dduan/DrString.vim](https://github.com/dduan/DrString.vim) provides Vim
wrappers for DrString.

## Emacs

[flycheck-drstring](https://github.com/danielmartin/flycheck-drstring) is
a flycheck checker for Swift source code using DrString.
