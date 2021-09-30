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

  def count_votes(%State{votes: votes}) do
    votes
    |> Map.values
    |> Enum.reduce(%{}, fn move, move_scores -> Map.update(move_scores, move, 1, &(&1 + 1)) end)
    |> Map.put_new("up", 0)
    |> Map.put_new("down", 0)
    |> Map.put_new("left", 0)
    |> Map.put_new("right", 0)
  end

  def top_vote(%State{} = state) do
    state
    |> count_votes
    |> Enum.sort(fn {_move_a, score_a}, {_move_b, score_b} -> score_a >= score_b end)
    |> Enum.at(0)
  end

  def update_last_move_played(%State{} = state, last_move_played) do
    %State{state | last_move_played: last_move_played}
  end

  def reset(last_move_played) do
    %State{last_move_played: last_move_played}
  end
end
