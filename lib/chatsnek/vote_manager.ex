defmodule ChatSnek.VoteManager do
  alias __MODULE__
  use Agent
  require Logger

  def start_link(_opts \\ %{}) do
    state = {%{}, nil}
    Agent.start_link(fn -> state end, name: VoteManager)
  end

  def cast_vote(move, voter) do
    Agent.update(VoteManager, fn {votes, last_move_played} ->
      next_votes = Map.put(votes, voter, move)
      {next_votes, last_move_played}
    end)
  end

  def finalize_vote() do
    Agent.get_and_update(VoteManager, fn {votes, last_move_played} ->
      top_vote = votes
      |> Map.values
      |> Enum.reduce(%{}, fn move, move_scores -> Map.update(move_scores, move, 1, &(&1 + 1)) end)
      |> Enum.sort(fn {_move_a, score_a}, {_move_b, score_b} -> score_a >= score_b end)
      |> Enum.at(0)

      case top_vote do
        nil -> {last_move_played, {votes, last_move_played}}
        {move, _score} -> {move, {%{}, move}}
      end
    end)
  end
end
