defmodule TaskTrackWeb.UserController do
  use TaskTrackWeb, :controller

  plug :auth_none when action in [:create, :new]

  alias TaskTrack.Accounts
  alias TaskTrack.Accounts.User

  defp auth_none(conn, _params) do
    case get_session(conn, :user_id) do
      nil -> conn
      _ ->
        conn
        |> put_flash(:error, "Cannot create user while logged in")
        |> redirect(to: "/")
        |> halt()
    end
  end

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: "/")
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    path = user_path(conn, :show, user)
    conn
    |> put_session(:redir, path)
    |> render("show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    changeset = Accounts.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    case Accounts.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    {:ok, _user} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end

  def unmanage(conn, %{"id" => employee_id}) do
    manage_help(conn, nil, employee_id)
  end

  def manage(conn, %{"id" => employee_id}) do
    manage_help(conn, get_session(conn, :user_id), employee_id)
  end

  def manage_help(conn, new_manager, employee_id) do
    IO.inspect(get_session(conn, :redir))
    manager = Accounts.get_user!(get_session(conn, :user_id))
    employee = Accounts.get_user!(employee_id)
    redir = get_session(conn, :redir) || "/"
    conn = delete_session(conn, :redir)

    if manager.level > employee.level do
      case Accounts.update_user(employee, %{manager_id: new_manager}) do
        {:ok, _employee} ->
          conn
          |> put_flash(:info, "Manager updated successfully.")
          |> redirect(to: redir)
        {:error, _} ->
          conn
          |> put_flash(:error, "Unable to update manager.")
          |> redirect(to: redir)
      end
    else
      conn
      |> put_flash(:error, "Your employee level is too low to set manager.")
      |> redirect(to: redir)
    end
  end

end
