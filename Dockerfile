FROM bitwalker/alpine-elixir:1.8.1 as builder

ENV REPLACE_OS_VARS=true
ENV SKIP_PHOENIX=true

# By convention, /opt is typically used for applications
WORKDIR /opt/app

# This step installs all the build tools we'll need
RUN apk update \
  && apk add git openssh-client libressl-dev \
  && apk add musl=1.1.20-r5 \
  && apk add --update alpine-sdk coreutils curl postgresql-client

# This copies our app source code into the build container
COPY . .

RUN mix local.hex --force
RUN mix local.rebar --force
RUN rm -rf ./deps ./_build ./.elixir_ls
RUN mix do deps.get, deps.compile, compile

RUN chmod +X ./runner.sh

EXPOSE 4000

CMD ["sh", "./runner.sh"]
