defmodule ChatSnek.VoteManager do
  use Agent

  alias __MODULE__
  alias __MODULE__.State

  def start_link(_opts \\ %{}) do
    Agent.start_link(fn -> State.new end, name: VoteManager)
  end

  def cast_vote(move, voter) do
    Agent.update(VoteManager, State, :cast_vote, [move, voter])
  end

  def finalize_vote() do
    Agent.get_and_update(VoteManager, fn state ->
      case State.top_vote(state) do
        nil ->
          {state.last_move_played, state}
        {top_move, _top_score} ->
          {top_move, State.reset(top_move)}
      end
    end)
  end
end
