defmodule TaskTrackWeb.UserView do
  use TaskTrackWeb, :view

  def render("created.json", %{}) do
    %{ status: :ok }
  end

  def render("users.json", %{users: users}) do
    %{
      status: :ok,
      data: Enum.map(users, fn(user) ->
        %{
          name: user.name,
          email: user.email
        }
      end)
    }
  end

  def render("error.json", %{changeset: changeset}) do
    IO.inspect(changeset)
    %{
      status: :error,
      fields: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
    }
  end
end
