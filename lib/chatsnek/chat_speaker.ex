defmodule ChatSnek.ChatSpeaker do
  def handle_game_started(_game_id) do
    say "Where should I go, chat? Commands are: !up !down !left !right"
  end

  def handle_game_move_decided(direction, turn) do
    emoji = direction_emoji(direction)
    next_turn = turn + 1
    say "#{emoji} Going #{direction} on turn #{turn}. Cast your votes for turn #{next_turn}!"
  end

  def handle_game_ended(_game_id) do
    say "gg"
  end

  defp say(message) do
    Application.get_env(:chatsnek, :twitch)
    |> Keyword.fetch!(:chat)
    |> TMI.message(message)
  end

  defp direction_emoji("up"), do: "⬆️"
  defp direction_emoji("down"), do: "⬇️"
  defp direction_emoji("left"), do: "⬅️"
  defp direction_emoji("right"), do: "➡️"
  defp direction_emoji(_direction), do: ""
end
