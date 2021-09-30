defmodule ChatSnek.MoveSafety do
  @moves ["up", "down", "left", "right"]

  def decide_safe_move(candidate_move, fallback_move, move_request) do
    safe_moves = safe_moves(move_request)
    no_moves_are_safe = Enum.empty?(safe_moves)

    if no_moves_are_safe do
      candidate_move || fallback_move
    else
      candidate_move_is_safe = candidate_move != nil && Enum.member?(safe_moves, candidate_move)

      if candidate_move_is_safe do
        candidate_move
      else
        Enum.random(safe_moves) || candidate_move || fallback_move
      end
    end
  end

  defp safe_moves(move_request) do
    width = move_request["board"]["width"]
    height = move_request["board"]["height"]
    head = move_request["you"]["head"]
    body = move_request["you"]["body"]
    food = move_request["board"]["food"] |> MapSet.new

    @moves |> Enum.reject(fn move ->
      new_head = step(head, move)
      out_of_bounds?(new_head, width, height) || self_collision?(new_head, body, food)
    end)
  end

  defp step(%{"x" => x, "y" => y} = _origin, move) do
    case move do
      "up" ->
        %{"x" => x, "y" => y + 1}
      "down" ->
        %{"x" => x, "y" => y - 1}
      "left" ->
        %{"x" => x - 1, "y" => y}
      "right" ->
        %{"x" => x + 1, "y" => y}
    end
  end

  defp out_of_bounds?(%{"x" => x, "y" => y}, width, height) do
    x < 0 || x >= width || y < 0 || y >= height
  end

  defp self_collision?(new_head, body, food) do
    will_eat = MapSet.member?(food, new_head)

    new_body = if will_eat do
      body
    else
      Enum.drop(body, -1)
    end

    Enum.any?(new_body, &(&1 == new_head))
  end
end
