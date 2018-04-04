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

  pipeline :unauthenticated do
    plug Guardian.Plug.EnsureNotAuthenticated
  end

  pipeline :authenticated do
    plug Guardian.Plug.Pipeline, module: TaskTrack.Guardian, error_handler: TaskTrackWeb.AuthErrorHandler
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.LoadResource
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", TaskTrackWeb do
    pipe_through([:api, :unauthenticated])
    post "/session", SessionController, :create_session
    post "/users/new", UserController, :create_user
  end

  scope "/api/v1", TaskTrackWeb do
    pipe_through([:api, :authenticated])
    post "/tasks", TaskController, :get_tasks
    get "/tasks/:task_id", TaskController, :get_task
    post "/tasks/new", TaskController, :create_task
    post "/tasks/:task_id", TaskController, :edit_task
    delete "/tasks/:task_id", TaskController, :delete_task
    get "/users", UserController, :get_users
  end

  scope "/", TaskTrackWeb do
    pipe_through :browser # Use the default browser stack
    get "/*path", PageController, :index
  end
end
