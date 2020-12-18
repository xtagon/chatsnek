defmodule ChatSnekVoteManagerTest do
  # Disable async mode because VoteManager is globally registered
  use ExUnit.Case, async: false

  alias ChatSnek.VoteManager
  alias ChatSnek.VoteManager.State

  test "voting workflow example" do
    assert {nil, 0} == VoteManager.finalize_vote

    VoteManager.cast_vote("left", "bob")
    VoteManager.cast_vote("right", "alice")
    VoteManager.cast_vote("right", "james")
    VoteManager.cast_vote("down", "sarah")

    assert {"right", 2} == VoteManager.finalize_vote

    assert {"right", 0} == VoteManager.finalize_vote

    VoteManager.cast_vote("up", "bob")

    assert {"up", 1} == VoteManager.finalize_vote
  end
end
