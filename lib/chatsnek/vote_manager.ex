defmodule ChatSnek.VoteManager do
  alias __MODULE__
  use Agent
  require Logger

  def start_link(_opts \\ %{}) do
    Agent.start_link(fn -> nil end, name: VoteManager)
  end

  def cast_vote(direction, sender) do
    Agent.update(VoteManager, fn _state -> direction end)
  end

  def most_recent_vote() do
    Agent.get(VoteManager, &(&1))
  end
end
