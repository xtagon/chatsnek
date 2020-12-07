defmodule ChatSnek.DebugLogger do
  require Logger

  def handle_game_started(game_id) do
    Logger.info("Game started: game_id=#{game_id}")
  end

  def handle_game_move_decided(direction) do
    Logger.info("Decided to move #{direction}")
  end

  def handle_game_ended(game_id) do
    Logger.info("Game ended: game_id=#{game_id}")
  end

  def handle_vote_cast(direction, voter) do
    Logger.info("Chat: #{voter} voted to move #{direction}")
  end
end
