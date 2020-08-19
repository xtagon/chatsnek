defmodule ChatSnekWeb.BattlesnakeController do
  use ChatSnekWeb, :controller
  alias ChatSnek.VoteManager
  require Logger

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

  def start(conn, params) do
    with %{"game" => %{"id" => game_id}} <- params do
      Logger.info("Game started: game_id=#{game_id}")
    end

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

    Logger.info("Decided to move #{direction}")

    json(conn, %{"move" => direction})
  end

  def _end(conn, params) do
    with %{"game" => %{"id" => game_id}} <- params do
      Logger.info("Game ended: game_id=#{game_id}")
    end

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
