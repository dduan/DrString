ARG BUILDER_IMAGE=swift:5.6.0-focal
ARG RUNTIME_IMAGE=ubuntu:focal

# builder image
FROM ${BUILDER_IMAGE} AS builder
RUN apt-get update && apt-get install -y make && rm -r /var/lib/apt/lists/*
WORKDIR /workdir/

COPY Sources Sources/
COPY Tests Tests/
COPY Scripts/locateswift.sh Scripts/locateswift.sh
COPY Scripts/completions/bash/drstring-completion.bash Scripts/completions/bash/drstring-completion.bash
COPY Scripts/completions/zsh/_drstring Scripts/completions/zsh/_drstring
COPY Scripts/completions/drstring.fish Scripts/completions/drstring.fish
COPY Makefile Makefile
COPY Package.* ./

RUN make build
RUN mkdir -p /executables
RUN mkdir -p /completions
RUN install -v .build/release/drstring-cli /executables/drstring
RUN install -v Scripts/completions/bash/drstring-completion.bash /completions/drstring-completion.bash
RUN install -v Scripts/completions/zsh/_drstring /completions/_drstring
RUN install -v Scripts/completions/drstring.fish /completions/drstring.fish

# runtime image
FROM ${RUNTIME_IMAGE}
LABEL org.opencontainers.image.source https://github.com/dduan/DrString
COPY --from=builder /usr/lib/swift/linux/libBlocksRuntime.so /usr/lib
COPY --from=builder /usr/lib/swift/linux/lib_InternalSwiftSyntaxParser.so /usr/lib
COPY --from=builder /executables/drstring /usr/bin
COPY --from=builder /completions/drstring-completion.bash /etc/bash_completion.d/drstring
COPY --from=builder /completions/_drstring /usr/share/zsh/vendor-completions/_drstring
COPY --from=builder /completions/drstring.fish /usr/share/fish/completions/drstring.fish


RUN drstring --version

CMD ["drstring", "check", "-i", "./**/*.swift"]
