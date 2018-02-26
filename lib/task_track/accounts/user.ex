defmodule TaskTrack.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaskTrack.Accounts.User


  schema "users" do
    field :email, :string
    field :name, :string
    field :level, :integer
    belongs_to :manager, TaskTrack.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :name, :level, :manager_id])
    |> validate_required([:email, :name, :level])
    |> unique_constraint(:email)
    |> validate_number(:level, greater_than: 0)
  end
end
