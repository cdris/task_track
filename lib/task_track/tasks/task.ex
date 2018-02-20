defmodule TaskTrack.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaskTrack.Tasks.Task


  schema "tasks" do
    field :completed, :boolean, default: false
    field :description, :string
    field :time_worked, :integer
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
                    :reporter_id, :time_worked, :completed])
    |> validate_required([:title, :description, :time_worked, :completed])
    |> validate_mod_15(:time_worked)
    |> change_user_id_email(:assignee_id, :assignee_email)
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

  def change_user_id_email(changeset, id_field, email_field) do
    IO.inspect(changeset)
    email = get_field(changeset, email_field)
    id = get_field(changeset, id_field)
    cond do
      email == nil && id == nil ->
        add_error(changeset, email_field, "can't be blank")
      id != nil ->
        user = TaskTrack.Accounts.get_user(id)
        case user do
          nil -> add_error(changeset, email_field, "Invalid user")
          _ -> change(changeset, %{email_field => user.email})
        end
      email != nil ->
        user = TaskTrack.Accounts.get_user_by_email(email)
        case user do
          nil -> add_error(changeset, email_field, "Invalid user")
          _ -> change(changeset, %{id_field => user.id})
        end
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
