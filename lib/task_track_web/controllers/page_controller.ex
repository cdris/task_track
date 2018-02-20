defmodule TaskTrackWeb.PageController do
  use TaskTrackWeb, :controller

  def index(conn, _params) do
    case get_session(conn, :user_id) do
      nil -> render conn, "index.html"
      _ -> redirect conn, to: "/tasks"
    end
  end
end
