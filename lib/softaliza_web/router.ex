defmodule SoftalizaWeb.Router do
  use SoftalizaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SoftalizaWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", SoftalizaWeb do
    pipe_through :api

    get "/events", EventController, :index
    get "/events/:id", EventController, :show

    get "/articles", ArticleController, :index
    get "/articles/:id", ArticleController, :show
  end

  scope "/api", SoftalizaWeb do
    pipe_through [:api, :authorize]

    post "/events", EventController, :create
    put "/events/:id", EventController, :update
    patch "/events/:id", EventController, :update
    delete "/events/:id", EventController, :delete

    post "/articles", ArticleController, :create
    put "/articles/:id", ArticleController, :update
    patch "/articles/:id", ArticleController, :update
    delete "/articles/:id", ArticleController, :delete
  end

  defp authorize(conn, _params) do
    token =
      conn
      |> get_req_header("authorization")
      |> List.last()

    secret = System.get_env("ADMIN_TOKEN") || "admin_secret"

    with "Token " <> token <- token,
         ^secret <- token do
      conn
    else
      _ ->
        conn
        |> SoftalizaWeb.ErrorResponse.unauthorized()
        |> halt()
    end
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
      pipe_through :browser
      live_dashboard "/dashboard", metrics: SoftalizaWeb.Telemetry
    end
  end
end
