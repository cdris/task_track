defmodule TaskTrackWeb.SessionController do
  use TaskTrackWeb, :controller

  alias TaskTrack.Accounts

  def create(conn, %{"email" => email, "password" => password}) do
    case Accounts.get_and_auth_user(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Welcome back, #{user.name}!")
        |> redirect(to: page_path(conn, :index))
      {:locked_out, _} ->
        conn
        |> put_flash(:error, "Locked out of account for 1 hour")
        |> redirect(to: page_path(conn, :index))
      _ ->
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
