# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :chatsnek,
  namespace: ChatSnek

# Configures the endpoint
config :chatsnek, ChatSnekWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "J1ulpV+qW+ockY5RCkcq0hT0DG3REfFP0y7NcWGTeS29riiPuSMSMHXwbESNO/WM",
  render_errors: [view: ChatSnekWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: ChatSnek.PubSub,
  live_view: [signing_salt: "CQ985njq"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
