defmodule ChatSnek.ChatHandler do
  use TMI.Handler
  alias ChatSnek.VoteManager

  @impl true
  def handle_message("!" <> direction, sender, _chat)
  when direction in ["up", "down", "left", "right"]
  do
    Logger.info("Chat: #{sender} voted to move #{direction}")
    VoteManager.cast_vote(direction, sender)
  end

  @impl true
  def handle_message(_message, _sender, _chat) do
    # Do nothing, just ignore anything that's not a command for us.
  end
end
