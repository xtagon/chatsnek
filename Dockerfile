FROM bitwalker/alpine-elixir-phoenix:latest

EXPOSE 5000

ARG SECRET_KEY_BASE=${SECRET_KEY_BASE}

ENV CHAT_USER
ENV CHAT_PASS
ENV CHAT_CHANNEL
ENV SNAKE_AUTHOR
ENV SNAKE_COLOR
ENV SNAKE_HEAD
ENV SNAKE_TAIL
ENV TURN_TIMEOUT_BUFFER

ENV PORT=5000 MIX_ENV=prod

ADD mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

ADD . .

RUN mix compile

USER default

CMD ["mix", "phx.server"]
