defmodule TaskTrackWeb.TimeBlockController do
  use TaskTrackWeb, :controller

  alias TaskTrack.Tasks
  alias TaskTrack.Tasks.TimeBlock

  action_fallback TaskTrackWeb.FallbackController

  def index(conn, _params) do
    time_blocks = Tasks.list_time_blocks()
    render(conn, "index.json", time_blocks: time_blocks)
  end

  def create(conn, %{"time_block" => time_block_params}) do
    with {:ok, %TimeBlock{} = time_block} <- Tasks.create_time_block(time_block_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", time_block_path(conn, :show, time_block))
      |> render("show.json", time_block: time_block)
    end
  end

  def show(conn, %{"id" => id}) do
    time_block = Tasks.get_time_block!(id)
    render(conn, "show.json", time_block: time_block)
  end

  def update(conn, %{"id" => id, "time_block" => time_block_params}) do
    time_block = Tasks.get_time_block!(id)

    with {:ok, %TimeBlock{} = time_block} <- Tasks.update_time_block(time_block, time_block_params) do
      render(conn, "show.json", time_block: time_block)
    end
  end

  def delete(conn, %{"id" => id}) do
    time_block = Tasks.get_time_block!(id)
    with {:ok, %TimeBlock{}} <- Tasks.delete_time_block(time_block) do
      send_resp(conn, :no_content, "")
    end
  end
end
