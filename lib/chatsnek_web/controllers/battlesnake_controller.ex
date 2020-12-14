defmodule ChatSnekWeb.BattlesnakeController do
  use ChatSnekWeb, :controller

  alias ChatSnek.{
    ChatSpeaker,
    DebugLogger,
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

  def move(conn, %{"game" => %{"timeout" => timeout}, "turn" => turn}) do
    WaitForTurn.wait_for_game_timeout(timeout)

    {move, shout} = case VoteManager.finalize_vote do
      {nil, _vote_counts} ->
        {"up", nil}
      {top_voted_move, vote_counts} ->
        {top_voted_move, shout_vote_counts(vote_counts)}
    end

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
