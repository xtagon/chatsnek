defmodule ChatSnek.DebugLogger do
  require Logger

  def handle_game_started(game_id) do
    Logger.info("Game started: game_id=#{game_id}")
  end

  def handle_game_move_decided(direction, turn, vote_counts) do
    tally = vote_counts[direction]
    pluralized_votes = if tally == 1, do: "vote", else: "votes"
    Logger.info("Decided to move #{direction} on turn #{turn} based on #{tally} #{pluralized_votes}")
  end

  def handle_game_ended(game_id) do
    Logger.info("Game ended: game_id=#{game_id}")
  end

  def handle_vote_cast(direction, voter) do
    Logger.info("Chat: #{voter} voted to move #{direction}")
  end

  def handle_chat_speaker_enabled(user_who_enabled) do
    Logger.info("Chat: #{user_who_enabled} enabled the chat speaker")
  end

  def handle_chat_speaker_disabled(user_who_disabled) do
    Logger.info("Chat: #{user_who_disabled} disabled the chat speaker")
  end
end
