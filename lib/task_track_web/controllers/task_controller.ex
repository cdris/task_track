defmodule TaskTrackWeb.TaskController do
  use TaskTrackWeb, :controller

  alias TaskTrack.Tasks

  def get_tasks(conn, params) do
    user = Guardian.Plug.current_resource(conn)
    show_completed = params["completed"] || false
    show_reported = params["reported"] || false
    tasks = Tasks.list_tasks(user.id, show_completed, show_reported)
    render(conn, "tasks.json", tasks: tasks)
  end

  def get_task(conn, %{"task_id" => task_id}) do
    case Tasks.get_task(task_id) do
      nil ->
        conn
        |> put_status(404)
        |> render(conn, "error.json", message: "No such task")
      task -> render(conn, "task.json", task: task)
    end
  end

  def create_task(conn, %{"task" => task_params}) do
    user = Guardian.Plug.current_resource(conn)
    task_params = Map.put(task_params, "reporter_id", user.id)
    case Tasks.create_task(task_params) do
      {:ok, _task} ->
        conn
        |> render("ok.json")
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(400)
        |> render("error.json", changeset: changeset)
    end
  end

  def edit_task(conn, %{"task_id" => task_id, "task" => task_params}) do
    case Tasks.get_task(task_id) do
      nil ->
        conn
        |> put_status(404)
        |> render("error.json", message: "No such task")
      task ->
        user = Guardian.Plug.current_resource(conn)
        task_params = Map.put(task_params, "reporter_id", user.id)
        case Tasks.update_task(task, task_params) do
          {:ok, _task} ->
            conn
            |> render("ok.json")
          {:error, %Ecto.Changeset{} = changeset} ->
            conn
            |> put_status(400)
            |> render("error.json", changeset: changeset)
        end
    end
  end

  def delete_task(conn, %{"task_id" => task_id}) do
    case Tasks.get_task(task_id) do
      nil ->
        conn
        |> put_status(404)
        |> render("error.json", message: "No such task")
      task ->
        {:ok, _task} = Tasks.delete_task(task)
        conn
        |> render("ok.json")
    end
  end
end
