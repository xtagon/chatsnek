defmodule ChatSnekWeb.BattlesnakeControllerTest do
  use ChatSnekWeb.ConnCase, async: true

  describe "index" do
    test "returns Battlesnake personlization JSON declaring Battlesnake API v1 compatibility", %{conn: conn} do
      path = Routes.battlesnake_path(conn, :index)
      conn = get(conn, path)

      assert json_response(conn, 200)["apiversion"] == "1"
    end
  end
end
