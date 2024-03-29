defmodule ChatSnekWeb.BattlesnakeController do
  use ChatSnekWeb, :controller

  alias ChatSnek.{
    ChatSpeaker,
    DebugLogger,
    MoveSafety,
    VoteManager,
    WaitForTurn
  }

  @default_move "up"

  def index(conn, _params) do
    config = get_config()
    json(conn, %{
      "apiversion" => "1",
      "version" => config[:version],
      "author" => config[:author],
      "color" => config[:color],
      "head" => config[:head],
      "tail" => config[:tail]
    })
  end

  def start(conn, %{"game" => %{"id" => game_id}}) do
    DebugLogger.handle_game_started(game_id)
    ChatSpeaker.handle_game_started(game_id)

    json(conn, %{})
  end

  def move(conn, %{"game" => %{"timeout" => timeout}, "turn" => turn} = params) do
    WaitForTurn.wait_for_game_timeout(timeout)

    {top_voted_move, vote_counts} = VoteManager.finalize_vote

    vote_had_participation = top_voted_move != nil && vote_counts[top_voted_move] > 0

    move = if vote_had_participation do
      top_voted_move
    else
      MoveSafety.decide_safe_move(top_voted_move, @default_move, params)
    end

    if move != top_voted_move do
      VoteManager.update_last_move_played(move)
    end

    shout = shout_vote_counts(vote_counts)

    DebugLogger.handle_game_move_decided(move, turn, vote_counts)
    ChatSpeaker.handle_game_move_decided(move, turn, vote_counts)

    json(conn, %{
      "move" => move,
      "shout" => shout
    })
  end

  def _end(conn, %{"game" => %{"id" => game_id}}) do
    DebugLogger.handle_game_ended(game_id)
    ChatSpeaker.handle_game_ended(game_id)

    json(conn, %{})
  end

  defp shout_vote_counts(vote_counts) do
    vote_counts
    |> Enum.map(fn {direction, score} -> "#{direction}:#{score}" end)
    |> Enum.join(", ")
  end

  defp get_config do
    Application.get_env(:chatsnek, :battlesnake)
  end
end
