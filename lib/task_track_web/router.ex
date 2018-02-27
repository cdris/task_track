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

  scope "/", TaskTrackWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    post "/session", SessionController, :create
    delete "/session", SessionController, :delete
    scope "/users" do
      post "/manage/:id", UserController, :manage
      post "/unmanage/:id", UserController, :unmanage
    end
    resources "/users", UserController, only: [:new, :create, :edit, :update, :show, :index]
    scope "/tasks" do
      post "/", TaskController, :index
      post "/new", TaskController, :create
    end
    resources "/tasks", TaskController
  end

  # Other scopes may use custom stacks.
  scope "/api", TaskTrackWeb do
    pipe_through :api
    resources "/time_blocks", TimeBlockController, except: [:new, :edit]
  end
end
