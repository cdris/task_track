defmodule TaskTrackWeb.PageController do
  use TaskTrackWeb, :controller

  def index(conn, _params) do
    user_id = get_session(conn, :user_id)
    if user_id && TaskTrack.Accounts.get_user(user_id) do
      redirect conn, to: "/tasks"
    else
      render conn, "index.html"
    end
  end
end
