defmodule ChatSnekWeb.BattlesnakeController do
  use ChatSnekWeb, :controller

  alias ChatSnek.ChatHandler
  alias ChatSnek.DebugLogger
  alias ChatSnek.VoteManager

  def index(conn, _params) do
    config = get_config()
    json(conn, %{
      "apiversion" => "1",
      "author" => config[:author],
      "color" => config[:color],
      "head" => config[:head],
      "tail" => config[:tail]
    })
  end

  def start(conn, %{"game" => %{"id" => game_id}}) do
    DebugLogger.handle_game_started(game_id)
    ChatHandler.handle_game_started(game_id)

    json(conn, %{})
  end

  def move(conn, params) do
    with %{"game" => %{"timeout" => timeout}} <- params do
      Process.sleep(buffered_timeout(timeout))
    end

    direction = case VoteManager.finalize_vote do
      nil -> "up"
      vote -> vote
    end

    DebugLogger.handle_game_move_decided(direction)
    ChatHandler.handle_game_move_decided(direction)

    json(conn, %{"move" => direction})
  end

  def _end(conn, %{"game" => %{"id" => game_id}}) do
    DebugLogger.handle_game_ended(game_id)
    ChatHandler.handle_game_ended(game_id)

    json(conn, %{})
  end

  defp buffered_timeout(game_timeout) do
    config = get_config()
    override = config[:turn_timeout_override]
    buffer = config[:turn_timeout_buffer]

    if is_integer(override) and override > 0 do
      override
    else
      max(0, min(game_timeout, game_timeout - buffer))
    end
  end

  defp get_config do
    Application.get_env(:chatsnek, :battlesnake)
  end
end
