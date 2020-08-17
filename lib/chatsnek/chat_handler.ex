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
end
