defmodule GothamManagerWeb.Router do
  use GothamManagerWeb, :router

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

  scope "/", GothamManagerWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", GothamManagerWeb do
    pipe_through :api

    scope "/users" do
      get "/", UserController, :index
      post "/", UserController, :create
      get "/:userID", UserController, :show
      put "/:userID", UserController, :update
      delete "/:userID", UserController, :delete
    end

    scope "/workingtimes" do
      get "/:userID", WorkingtimeController, :index
      get "/:userID/:id", WorkingtimeController, :show
      post "/:userID", WorkingtimeController, :create
      put "/:id", WorkingtimeController, :update
      delete "/:id", WorkingtimeController, :delete
    end

    scope "/clocks" do
      get "/:userID", ClockController, :index
      post "/:userID", ClockController, :create
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
      live_dashboard "/dashboard", metrics: GothamManagerWeb.Telemetry
    end
  end
end
