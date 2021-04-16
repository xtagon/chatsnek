defmodule ChatSnekWeb.BattlesnakeController do
  use ChatSnekWeb, :controller

  alias ChatSnek.{
    ChatSpeaker,
    DebugLogger,
    MoveSafety,
    VoteManager,
    WaitForTurn
  }

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

    move = if top_voted_move != nil && vote_counts[top_voted_move] > 0 do
      top_voted_move
    else
      safe_move = MoveSafety.safe_moves(params) |> Enum.random
      safe_move || top_voted_move || "up"
    end

    shout = shout_vote_counts(vote_counts)

    DebugLogger.handle_game_move_decided(move, turn)
    ChatSpeaker.handle_game_move_decided(move, turn)

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
