defmodule ChatSnek.ChatSpeaker do
  def handle_game_started(_game_id) do
    say "Where should I go, chat? Commands are: !up !down !left !right"
  end

  def handle_game_move_decided(direction) do
    emoji = direction_emoji(direction)
    say "#{emoji} Going #{direction} now. Where should I go next?"
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
