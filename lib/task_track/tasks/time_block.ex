defmodule TaskTrack.Tasks.TimeBlock do
  use Ecto.Schema
  import Ecto.DateTime
  import Ecto.Changeset
  import Map
  import Timex
  alias TaskTrack.Tasks.TimeBlock


  schema "time_blocks" do
    field :end_time, :utc_datetime
    field :start_time, :utc_datetime
    belongs_to :task, TaskTrack.Tasks.Task

    timestamps()
  end

  @doc false
  def changeset(%TimeBlock{} = time_block, attrs) do
    IO.puts("block")
    IO.inspect(time_block)
    IO.puts("attrs")
    IO.inspect(attrs)

    attrs =
      attrs
      |> parse_datetime("start_time")
      |> parse_datetime("end_time")

    IO.puts("attrs2")
    IO.inspect(attrs)

    time_block
    |> cast(attrs, [:start_time, :end_time, :task_id])
    |> validate_required([:start_time, :end_time, :task_id])
    |> validate_timestamp_lt(:start_time, :end_time)
  end

  def parse_datetime(attrs, field) do
    val = get(attrs, field)
    case Timex.parse(val, "{YYYY}-{0M}-{0D} {h24}:{m}") do
      {:ok, parsed} ->
        IO.puts("parsed")
        IO.inspect(parsed)
        put(attrs, field, parsed)
      _ ->
        IO.puts("fail")
        IO.inspect(val)
        attrs
    end
  end

  def validate_timestamp_lt(changeset, start_field, end_field) do
    start_time = get_field(changeset, start_field)
    end_time = get_field(changeset, end_field)
    cond do
      start_time == nil -> add_error(changeset, start_field, "Can't be empty")
      end_time == nil -> add_error(changeset, end_field, "Can't be empty")
      Timex.compare(start_time, end_time) < 0 -> changeset
      true -> add_error(changeset, end_field, "End time must be later than start time")
    end
  end
end
