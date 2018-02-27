defmodule TaskTrackWeb.TaskView do
  use TaskTrackWeb, :view
  import Timex
  alias TaskTrack.Tasks

  def time_worked(task_id) do
    div(Tasks.get_time_worked(task_id), 60)
  end

  def format(dt) do
    case Timex.format(dt, "{YYYY}-{0M}-{0D} {h24}:{m}") do
      {:ok, formatted} -> formatted
      _ -> dt
    end
  end

end
