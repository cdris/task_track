defmodule TaskTrack.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaskTrack.Tasks.Task


  schema "tasks" do
    field :completed, :boolean, default: false
    field :description, :string
    field :title, :string
    field :assignee_email, :string, virtual: true
    belongs_to :assignee, TaskTrack.Accounts.User
    belongs_to :reporter, TaskTrack.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:title, :description, :assignee_id, :assignee_email,
                    :reporter_id, :completed])
    |> validate_required([:title, :description, :completed])
    |> change_user_id_email(:assignee_id, :assignee_email, :reporter_id)
    |> validate_user_id(:reporter_id)
  end

  # based on examples here: http://blog.danielberkompas.com/elixir/2015/05/20/useful-ecto-validators.html
  def validate_mod_15(changeset, field, options \\[]) do
    validate_change(changeset, field, fn _, num ->
      cond do
        rem(num, 15) == 0 && num >= 0 -> []
        true -> [{field, options[:message] || "Not an increment of 15"}]
      end
    end)
  end

  def change_user_id_email(changeset, id_field, email_field, reporter_field) do
    email = get_field(changeset, email_field)
    id = get_field(changeset, id_field)
    reporter_id = get_field(changeset, reporter_field)
    cond do
      email == nil && id == nil ->
        add_error(changeset, email_field, "can't be blank")
      id != nil ->
        user = TaskTrack.Accounts.get_user(id)
        reporter_check(changeset, email_field, user.email, email_field, user, reporter_id)
      email != nil ->
        user = TaskTrack.Accounts.get_user_by_email(email)
        reporter_check(changeset, id_field, user.id, email_field, user, reporter_id)
    end
  end

  def reporter_check(changeset, set_field, val, error_field, user, reporter_id) do
    cond do
      user == nil -> add_error(changeset, error_field, "Invalid user")
      user.id == reporter_id || (user.manager && user.manager.id == reporter_id) ->
        change(changeset, %{set_field => val})
      true -> add_error(changeset, error_field, "You do not have permission to assign this task")
    end
  end

  def validate_user_id(changeset, field, options \\[]) do
    validate_change(changeset, field, fn _, id ->
      case id && TaskTrack.Accounts.get_user(id) do
        nil -> [{field, options[:message] || "Invalid user"}]
        _ -> []
      end
    end)
  end
end
