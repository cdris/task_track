defmodule TaskTrackWeb.SessionController do
  use TaskTrackWeb, :controller

  alias TaskTrack.Accounts
  alias TaskTrack.Accounts.User

  def create(conn, %{"email" => email}) do
    user = Accounts.get_user_by_email(email)
    if user do
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Welcome back, #{user.name}!")
        |> redirect(to: page_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Login failed")
      |> redirect(to: page_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "Logged out successfully")
    |> redirect(to: page_path(conn, :index))
  end
end
