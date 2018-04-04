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

  def create_json(conn, %{"email" => email, "password" => password}) do
    result = Accounts.get_and_auth_user(email, password)
    IO.inspect(result)
    case result do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = TaskTrack.Guardian.encode_and_sign(user)
        conn
        |> render("created.json", user: user, jwt: jwt)
      {:locked_out, _} ->
        conn
        |> put_status(401)
        |> render("error.json", message: "Locked out of account for 1 hour")
      _ ->
        conn
        |> put_status(401)
        |> render("error.json", message: "Login failed")
    end
  end

  def get_json(conn, _params) do
    conn
    |> render("ok.json")
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "Logged out successfully")
    |> redirect(to: page_path(conn, :index))
  end
end
