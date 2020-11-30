defmodule ChatSnek.ChatHandler do
  use TMI.Handler
  alias ChatSnek.VoteManager

  @directions ["up", "down", "left", "right"]

  @impl true
  def handle_message("!" <> message, sender, chat) do
    handle_message(message, sender, chat)
  end

  @impl true
  def handle_message(message, sender, chat) do
    message
    |> String.trim
    |> String.downcase
    |> handle_command(sender, chat)
  end

  def handle_command(direction, sender, _chat) when direction in @directions do
    Logger.info("Chat: #{sender} voted to move #{direction}")
    VoteManager.cast_vote(direction, sender)
  end

  # Ignore anything that isn't a valid command
  def handle_command(_command, _sender, _chat), do: nil

  def handle_game_started do
    say "Where should I go, chat? Commands are: !up !down !left !right"
  end

  def handle_game_move_decided(direction) do
    emoji = direction_emoji(direction)
    say "#{emoji} Going #{direction} now. Where should I go next?"
  end

  def handle_game_ended do
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
