defmodule ChatSnek.MoveSafety do
  @moves ["up", "down", "left", "right"]

  def safe_moves(move_request) do
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
