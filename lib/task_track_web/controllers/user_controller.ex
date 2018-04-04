defmodule TaskTrackWeb.UserController do
  use TaskTrackWeb, :controller

  alias TaskTrack.Accounts

  def get_users(conn, _params) do
    users = Accounts.list_users()
    render(conn, "users.json", users: users)
  end

  def create_user(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, _user} ->
        conn
        |> render("created.json");
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(400)
        |> render("error.json", changeset: changeset)
    end
  end
end
