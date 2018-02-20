defmodule TaskTrackWeb.Plugs do
  import Plug.Conn

  def get_current_user(conn, _params) do
    user_id = get_session(conn, :user_id)
    user = TaskTrack.Accounts.get_user(user_id || -1)
    assign(conn, :current_user, user)
  end
end
