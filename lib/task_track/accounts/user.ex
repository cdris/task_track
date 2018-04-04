defmodule TaskTrack.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaskTrack.Accounts.User

  # based on Prof. Tuck's microblog user code
  schema "users" do
    field :email, :string
    field :name, :string

    field :password_hash, :string
    field :pw_tries, :integer
    field :pw_last_try, :utc_datetime

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :name, :password, :password_confirmation])
    |> validate_required([:email, :name, :password, :password_confirmation])
    |> unique_constraint(:email)
    |> validate_confirmation(:password)
    |> validate_password(:password)
    |> put_pass_hash()
  end

  # Password validation
  # From Comeonin docs
  def validate_password(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, password ->
      case valid_password?(password) do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || msg}]
      end
    end)
  end

  def valid_password?(password) when byte_size(password) >= 10 do
    {:ok, password}
  end
  def valid_password?(_), do: {:error, "Password must be at least 10 characters long"}

  def put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, Comeonin.Argon2.add_hash(password))
  end
  def put_pass_hash(changeset), do: changeset

  def pw_attempt(user, password) do
    now = DateTime.utc_now()
    tries = cond do
      user.pw_last_try != nil and DateTime.diff(now, user.pw_last_try, :second) > 3600 -> 0
      true -> user.pw_tries
    end

    cond do
      tries < 20 ->
        case Comeonin.Argon2.check_pass(user, password) do
          {:ok, _} ->
            user = user
                   |> change(pw_last_try: now)
                   |> change(pw_tries: tries)
            {:ok, user}
          _ ->
            user = user
                   |> change(pw_last_try: now)
                   |> change(pw_tries: tries + 1)
            {:login_failed, user}
        end
      true -> {:locked_out, change(user)}
    end
  end
end
