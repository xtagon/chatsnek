defmodule ChatSnekVoteManagerStateTest do
  use ExUnit.Case, async: true

  alias ChatSnek.VoteManager.State

  test "new state starts with empty votes map" do
    state = State.new

    assert state.votes == %{}
  end

  test "new state starts with no last move played" do
    state = State.new

    assert state.last_move_played == nil
  end

  test "casting a vote records it in the vote map" do
    state0 = State.new
    state1 = state0 |> State.cast_vote("left", "bob")
    state2 = state1 |> State.cast_vote("right", "alice")

    assert state1.votes == %{"bob" => "left"}
    assert state2.votes == %{"bob" => "left", "alice" => "right"}
  end

  test "counting votes when there are no votes returns zero for all voted directions" do
    vote_counts = State.new |> State.count_votes

    assert vote_counts == %{
      "up" => 0,
      "down" => 0,
      "left" => 0,
      "right" => 0
    }
  end

  test "counting votes returns the respective vote counts for each direction" do
    vote_counts = State.new
    |> State.cast_vote("up", "bob")
    |> State.cast_vote("left", "alice")
    |> State.cast_vote("left", "john")
    |> State.count_votes

    assert vote_counts == %{
      "up" => 1,
      "down" => 0,
      "left" => 2,
      "right" => 0
    }
  end

  test "getting the top vote returns the top vote and its score" do
    top_vote = State.new
    |> State.cast_vote("up", "bob")
    |> State.cast_vote("left", "alice")
    |> State.cast_vote("left", "john")
    |> State.top_vote

    assert {top_move, top_score} = top_vote
    assert top_move == "left"
    assert top_score == 2
  end

  test "resetting state starts over with no votes" do
    state = State.reset("right")

    assert state.votes == %{}
  end

  test "resetting state records the last move played" do
    state = State.reset("right")

    assert state.last_move_played == "right"
  end
end
