defmodule ChatSnek.Config do
  use Vapor.Planner

  dotenv()

  config :tmi, env([
    {:user, "CHAT_USER", required: true},
    {:pass, "CHAT_PASS", required: true},
    {:chats, "CHAT_CHANNEL", required: true, map: fn channel -> [channel] end}
  ])

  config :battlesnake, env([
    {:snake_author, "SNAKE_AUTHOR", required: false},
    {:snake_color, "SNAKE_COLOR", required: false},
    {:snake_head, "SNAKE_HEAD", required: false},
    {:snake_tail, "SNAKE_TAIL", required: false},
    {:turn_timeout_buffer, "TURN_TIMEOUT_BUFFER", required: true, map: &String.to_integer/1},
    {:turn_timeout_override, "TURN_TIMEOUT_OVERRIDE", required: false, map: &String.to_integer/1}
  ])
end
