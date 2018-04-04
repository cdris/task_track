defmodule TaskTrackWeb.TaskView do
  use TaskTrackWeb, :view

  def render("tasks.json", %{tasks: tasks}) do
    %{
      status: :ok,
      data: Enum.map(tasks, fn (task) ->
        %{
          title: task.title,
          description: task.description,
          reporter: task.reporter.name,
          assignee: task.assignee.name,
          time_worked: task.time_worked,
          completed: task.completed,
          id: task.id
        }
      end)
    }
  end

  def render("task.json", %{task: task}) do
    %{
      status: :ok,
      data: %{
        id: task.id,
        title: task.title,
        description: task.description,
        assignee_email: task.assignee.email,
        time_worked: task.time_worked,
        completed: task.completed
      }
    }
  end

  def render("ok.json", %{}) do
    %{ status: :ok }
  end

  def render("error.json", %{message: message}) do
    %{
      status: :error,
      message: message
    }
  end

  def render("error.json", %{changeset: changeset}) do
    IO.inspect(changeset)
    %{
      status: :error,
      fields: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
    }
  end
end
