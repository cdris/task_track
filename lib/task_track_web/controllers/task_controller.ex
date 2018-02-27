defmodule TaskTrackWeb.TaskController do
  use TaskTrackWeb, :controller

  alias TaskTrack.Tasks
  alias TaskTrack.Tasks.Task

  def index(conn, params) do
    show_completed = params["task_filter"]["show_completed"] == "true"
    show_employee_tasks = params["task_filter"]["show_employee_tasks"] == "true"
    user_id = get_session(conn, :user_id)
    tasks = if show_employee_tasks do
      Tasks.list_employee_tasks(user_id, show_completed)
    else
      Tasks.list_tasks(user_id, show_completed)
    end
    render(conn,
           "index.html",
           tasks: tasks,
           show_employee_tasks: show_employee_tasks,
           show_completed: show_completed)
  end

  def new(conn, _params) do
    changeset = Tasks.change_task(%Task{})
    user = TaskTrack.Accounts.get_user(get_session(conn, :user_id))
    users = [user | TaskTrack.Accounts.list_employees(user.id)]
    render(conn, "new.html", changeset: changeset, users: users)
  end

  def create(conn, %{"task" => task_params}) do
    task_params = Map.put(task_params, "reporter_id", get_session(conn, :user_id))
    user = TaskTrack.Accounts.get_user(get_session(conn, :user_id))
    case Tasks.create_task(task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: task_path(conn, :show, task))
      {:error, %Ecto.Changeset{} = changeset} ->
        users = [user | TaskTrack.Accounts.list_employees(user.id)]
        render(conn, "new.html", changeset: changeset, users: users)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    time_blocks = Tasks.list_time_blocks(id)
    render(conn, "show.html", task: task, time_blocks: time_blocks)
  end

  def edit(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    changeset = Tasks.change_task(task)
    user = TaskTrack.Accounts.get_user(get_session(conn, :user_id))
    users = [user | TaskTrack.Accounts.list_employees(user.id)]
    render(conn, "edit.html", task: task, changeset: changeset, users: users)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Tasks.get_task!(id)
    task_params = Map.put(task_params, "reporter_id", get_session(conn, :user_id))
    user = TaskTrack.Accounts.get_user(get_session(conn, :user_id))
    case Tasks.update_task(task, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: task_path(conn, :show, task))
      {:error, %Ecto.Changeset{} = changeset} ->
        users = [user | TaskTrack.Accounts.list_employees(user.id)]
        render(conn, "edit.html", task: task, changeset: changeset, users: users)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    {:ok, _task} = Tasks.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: task_path(conn, :index))
  end
end
