FROM bitwalker/alpine-elixir:1.7.3 AS builder
ARG BUILD_VERSION

ENV HOME=/app \
    TERM=xterm\
    MIX_ENV=prod \
    REPLACE_OS_VARS=true \
    PROJECT_NAME=elixir_app

WORKDIR ${HOME}

RUN mkdir config lib

# Install dependencies
RUN apk update && \
    apk add --virtual \
    build-dependencies \
    build-base \
    openssl-dev \
    zlib \
    zlib-dev \
    make && \
    mix do local.hex --force && \
    mix do local.rebar --force

COPY elixir_package elixir_package
COPY mix.exs mix.exs
COPY mix.lock mix.lock
RUN mix do deps.get, deps.compile

COPY config config
COPY lib lib
COPY rel rel

RUN mix do compile

RUN MIX_ENV=prod mix release
RUN mv ${HOME}/_build/prod/rel/$PROJECT_NAME/releases/$BUILD_VERSION/$PROJECT_NAME.tar.gz /build.tar.gz
RUN rm -rf ${HOME}

FROM bitwalker/alpine-elixir:1.7.3
ARG BUILD_VERSION

ENV PROJECT_NAME=elixir_app \
    HOME=/app \
    REPLACE_OS_VARS=true

WORKDIR ${HOME}

RUN mkdir -p ${HOME}
RUN apk add --update screen curl erlang-tools

COPY --from=builder /build.tar.gz ${HOME}/build.tar.gz

RUN tar -zxvf build.tar.gz; rm build.tar.gz

WORKDIR ${HOME}
RUN printf "#!/bin/ash\n./bin/elixir_app start; sleep 5; cat lib/elixir_package-0.0.1/install.log; ash" > ${HOME}/run && chmod +x ${HOME}/run

ENTRYPOINT ["./run"]
