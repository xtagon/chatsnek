defmodule ChatSnek.VoteManager.State do
  defstruct [
    votes: %{},
    last_move_played: nil
  ]

  alias __MODULE__

  def new do
    %State{}
  end

  def cast_vote(%State{} = state, move, voter) do
    next_votes = Map.put(state.votes, voter, move)
    %State{state | votes: next_votes}
  end

  def top_vote(%State{votes: votes}) do
    votes
    |> Map.values
    |> Enum.reduce(%{}, fn move, move_scores -> Map.update(move_scores, move, 1, &(&1 + 1)) end)
    |> Enum.sort(fn {_move_a, score_a}, {_move_b, score_b} -> score_a >= score_b end)
    |> Enum.at(0)
  end

  def reset(last_move_played) do
    %State{last_move_played: last_move_played}
  end
end
