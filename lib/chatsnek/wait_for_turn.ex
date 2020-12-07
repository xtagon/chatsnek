defmodule ChatSnek.WaitForTurn do
  @default_timeout 500 # milliseconds

  def wait_for_game_timeout(timeout \\ @default_timeout) do
    timeout
    |> buffered_timeout
    |> Process.sleep
  end

  defp buffered_timeout(timeout) do
    config = get_config()
    override = config[:turn_timeout_override]
    buffer = config[:turn_timeout_buffer]

    if is_integer(override) and override > 0 do
      override
    else
      max(0, min(timeout, timeout - buffer))
    end
  end

  defp get_config do
    Application.get_env(:chatsnek, :battlesnake)
  end
end
