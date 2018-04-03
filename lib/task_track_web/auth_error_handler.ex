defmodule TaskTrackWeb.AuthErrorHandler do
  import Plug.Conn

  def auth_error(conn, {type, reason}, _opts) do
    send_resp(conn, 401, to_string(type))
  end
end
