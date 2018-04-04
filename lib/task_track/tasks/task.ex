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
    |> cast(attrs, [:title, :description, :assignee_email,
                    :reporter_id, :time_worked, :completed])
    |> validate_required([:title, :description, :time_worked, :completed, :assignee_email])
    |> validate_mod_15(:time_worked)
    |> put_assignee_id()
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

  def put_assignee_id(changeset) do
    case get_field(changeset, :assignee_email) do
      nil ->
        add_error(changeset, :assignee_email, "can't be blank")
      email ->
        user = TaskTrack.Accounts.get_user_by_email(email)
        case user do
          nil -> add_error(changeset, :assignee_email, "Invalid user")
          _ -> change(changeset, %{:assignee_id => user.id})
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
