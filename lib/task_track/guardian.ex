defmodule TaskTrack.Guardian do
  use Guardian, otp_app: :task_track

  alias TaskTrack.Accounts
  alias TaskTrack.Accounts.User

  # Guardian usage is based on the guardian documentation here: https://github.com/ueberauth/guardian
  # Inspired to use guardian by piazza post with links to jwt guardian tutorials, however those tutorials are now out of date with the current version of guardian

  def subject_for_token(user = %User{}, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, "No such resource"}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = Accounts.get_user(id)
    {:ok, resource}
  end

  def resource_from_claims(_claims) do
    {:error, "No such resource"}
  end
end
