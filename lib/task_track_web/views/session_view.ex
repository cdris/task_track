defmodule TaskTrackWeb.SessionView do
  use TaskTrackWeb, :view

  def render("session_created.json", %{user: user, jwt: jwt}) do
    %{
      status: :ok,
      data: %{token: jwt}
    }
  end

  def render("error.json", %{message: message}) do
    %{
      status: :error,
      message: message
    }
  end

  def render("ok.json", %{}) do
    %{
      status: :ok,
      message: "it works!"
    }
  end
end
