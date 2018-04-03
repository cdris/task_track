defmodule TaskTrackWeb.Router do
  use TaskTrackWeb, :router
  import TaskTrackWeb.Plugs

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :get_current_user
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug Guardian.Plug.Pipeline, module: TaskTrack.Guardian, error_handler: TaskTrackWeb.AuthErrorHandler
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.LoadResource
  end

  scope "/", TaskTrackWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    post "/session", SessionController, :create
    delete "/session", SessionController, :delete
    resources "/users", UserController, only: [:new, :create]
    resources "/tasks", TaskController
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", TaskTrackWeb do
    pipe_through([:api])
    post "/session", SessionController, :create_json
  end

  scope "/api/v1", TaskTrackWeb do
    pipe_through([:api, :authenticated])
    get "/session", SessionController, :get_json
  end
end
