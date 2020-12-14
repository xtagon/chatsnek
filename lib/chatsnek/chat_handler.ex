defmodule ChatSnek.ChatHandler do
  use TMI.Handler

  alias ChatSnek.DebugLogger
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
    DebugLogger.handle_vote_cast(direction, sender)
    VoteManager.cast_vote(direction, sender)
  end

  def handle_command("u", sender, chat), do: handle_command("up", sender, chat)
  def handle_command("d", sender, chat), do: handle_command("down", sender, chat)
  def handle_command("l", sender, chat), do: handle_command("left", sender, chat)
  def handle_command("r", sender, chat), do: handle_command("right", sender, chat)

  # Ignore anything that isn't a valid command
  def handle_command(_command, _sender, _chat), do: nil
end
