defmodule ChatSnek.ChatSpeaker do
  use Agent

  alias __MODULE__
  alias __MODULE__.State

  def start_link(_opts \\ %{}) do
    Agent.start_link(fn -> State.new end, name: ChatSpeaker)
  end

  def enable do
    Agent.update(ChatSpeaker, State, :enable, [])
  end

  def disable do
    Agent.update(ChatSpeaker, State, :disable, [])
  end

  def enabled? do
    Agent.get(ChatSpeaker, State, :enabled?, [])
  end

  def handle_game_started(_game_id) do
    if enabled?() do
      say "Where should I go, chat? Commands are: !up !down !left !right"
    end
  end

  def handle_game_move_decided(direction, turn) do
    if enabled?() do
      emoji = direction_emoji(direction)
      next_turn = turn + 1
      say "#{emoji} Going #{direction} on turn #{turn}. Cast your votes for turn #{next_turn}!"
    end
  end

  def handle_game_ended(_game_id) do
    if enabled?() do
      say "gg"
    end
  end

  def handle_wtf do
    if enabled?() do
      say "Hey, I'm not the one driving, chat ;)"
    end
  end

  defp say(message) do
    Application.get_env(:chatsnek, :twitch)
    |> Keyword.fetch!(:chat)
    |> TMI.message(message)
  end

  defp direction_emoji("up"), do: "⬆️"
  defp direction_emoji("down"), do: "⬇️"
  defp direction_emoji("left"), do: "⬅️"
  defp direction_emoji("right"), do: "➡️"
  defp direction_emoji(_direction), do: ""
end
