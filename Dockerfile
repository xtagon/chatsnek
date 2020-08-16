FROM bitwalker/alpine-elixir-phoenix:latest

EXPOSE 5000

ARG SECRET_KEY_BASE=${SECRET_KEY_BASE}
ENV PORT=5000 MIX_ENV=prod

ADD mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

ADD . .

RUN mix compile

USER default

CMD ["mix", "phx.server"]
