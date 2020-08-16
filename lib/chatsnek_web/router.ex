defmodule ChatSnekWeb.Router do
  use ChatSnekWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ChatSnekWeb do
    pipe_through :api

    get "/", BattlesnakeController, :index
    post "/start", BattlesnakeController, :start
    post "/move", BattlesnakeController, :move
    post "/end", BattlesnakeController, :_end
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: ChatSnekWeb.Telemetry
    end
  end
end
