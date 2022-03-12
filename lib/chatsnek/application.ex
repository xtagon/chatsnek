defmodule ChatSnek.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    config = Vapor.load!(ChatSnek.Config)

    Application.put_env(:chatsnek, :battlesnake, [
      author: config.battlesnake.snake_author,
      version: config.battlesnake.snake_version,
      color: config.battlesnake.snake_color,
      head: config.battlesnake.snake_head,
      tail: config.battlesnake.snake_tail,
      turn_timeout_buffer: config.battlesnake.turn_timeout_buffer,
      turn_timeout_override: config.battlesnake.turn_timeout_override
    ])

    twitch_channel = List.first(config.tmi.channels)
    twitch_channels = [twitch_channel]

    Application.put_env(:chatsnek, :twitch, [
      channel: twitch_channel,
      admins: config.tmi.admins
    ])

    tmi_opts = [
      bot: ChatSnek.ChatHandler,
      user: config.tmi.user,
      pass: config.tmi.pass,
      channels: twitch_channels,
      capabilities: ["tags", "commands"]
    ]

    children = [
      # Start the Telemetry supervisor
      ChatSnekWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ChatSnek.PubSub},
      # Start the Endpoint (http/https)
      ChatSnekWeb.Endpoint,
      # Start the vote manager
      ChatSnek.VoteManager,
      # Start the chat speaker
      ChatSnek.ChatSpeaker,
      # Start the chat handler
      {TMI.Supervisor, tmi_opts}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ChatSnek.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ChatSnekWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
