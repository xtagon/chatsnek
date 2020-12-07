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

  def move(conn, %{"game" => %{"timeout" => timeout}}) do
    WaitForTurn.wait_for_game_timeout(timeout)

    direction = case VoteManager.finalize_vote do
      nil -> "up"
      vote -> vote
    end

    DebugLogger.handle_game_move_decided(direction)
    ChatSpeaker.handle_game_move_decided(direction)

    json(conn, %{"move" => direction})
  end

  def _end(conn, %{"game" => %{"id" => game_id}}) do
    DebugLogger.handle_game_ended(game_id)
    ChatSpeaker.handle_game_ended(game_id)

    json(conn, %{})
  end

  defp get_config do
    Application.get_env(:chatsnek, :battlesnake)
  end
end
