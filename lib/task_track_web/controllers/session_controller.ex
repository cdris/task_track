defmodule TaskTrackWeb.SessionController do
  use TaskTrackWeb, :controller

  alias TaskTrack.Accounts

  def create_session(conn, %{"email" => email, "password" => password}) do
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

end
