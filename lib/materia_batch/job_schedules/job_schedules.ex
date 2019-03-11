defmodule MateriaBatch.JobSchedules do
  @moduledoc """
  The JobSchedules context.
  """

  import Ecto.Query, warn: false

  alias MateriaBatch.JobSchedules.JobSchedule
  alias MateriaUtils.Ecto.EctoUtil

  @repo Application.get_env(:materia, :repo)

  @doc """
  Returns the list of job_schedules.

  ## Examples

  iex> job_schedule = MateriaBatch.JobSchedules.list_job_schedules() |> Enum.at(0)
  iex> job_schedule.name
  "実行対象ジョブ"

  """
  def list_job_schedules do
    @repo.all(JobSchedule)
  end

  @doc """

  JobSchedule汎用検索

  """
  def list_job_schedules_by_params(params) do
    @repo
    |> EctoUtil.select_by_param(JobSchedule, params)
  end

  @doc """
  Gets a single job_schedule.

  Raises `Ecto.NoResultsError` if the Job schedule does not exist.

  ## Examples

  iex> job_schedule = MateriaBatch.JobSchedules.get_job_schedule!(1)
  iex> job_schedule.name
  "実行対象ジョブ"

    # iex> get_job_schedule!(456)
    # ** (Ecto.NoResultsError)

  """
  def get_job_schedule!(id), do: @repo.get!(JobSchedule, id)

  @doc """
  Creates a job_schedule.

  ## Examples

  iex> now_datetime = MateriaUtils.Calendar.CalendarUtil.now()
  iex> params = %{"job_code" => "create_job_schedule_test001", "name" => "job name", "module" => "Process", "function" => "sleep", "schedule_datetime" => now_datetime, "next_check_datetime" => now_datetime, "error_action" => "abort", "priority" => 100, "status" => "I"}
  iex> {:ok, new_job_schedule} = MateriaBatch.JobSchedules.create_job_schedule(params)
  iex> created_job_schedule = MateriaBatch.JobSchedules.get_job_schedule!(new_job_schedule.id)
  iex> created_job_schedule.job_code
  "create_job_schedule_test001"

  """
  def create_job_schedule(attrs \\ %{}) do
    %JobSchedule{}
    |> JobSchedule.create_changeset(attrs)
    |> @repo.insert()
  end

  @doc """
  Updates a job_schedule.

  ## Examples

  iex> now_datetime = MateriaUtils.Calendar.CalendarUtil.now()
  iex> params = %{"job_code" => "update_job_schedule_test001", "name" => "job name", "module" => "Process", "function" => "sleep", "schedule_datetime" => now_datetime, "next_check_datetime" => now_datetime, "error_action" => "abort", "priority" => 100, "status" => "I"}
  iex> {:ok, new_job_schedule} = MateriaBatch.JobSchedules.create_job_schedule(params)
  iex> {:ok, updated_job_schedule} = MateriaBatch.JobSchedules.update_job_schedule(new_job_schedule, %{status: "S"})
  iex> updated_job_schedule = MateriaBatch.JobSchedules.get_job_schedule!(updated_job_schedule.id)
  iex> updated_job_schedule.status
  "S"

  """
  def update_job_schedule(%JobSchedule{} = job_schedule, attrs) do
    job_schedule
    |> JobSchedule.update_changeset(attrs)
    |> @repo.update()
  end

  @doc """
  Deletes a JobSchedule.

  ## Examples

  iex> now_datetime = MateriaUtils.Calendar.CalendarUtil.now()
  iex> params = %{"job_code" => "delete_job_schedule_test001", "name" => "job name", "module" => "Process", "function" => "sleep", "schedule_datetime" => now_datetime, "next_check_datetime" => now_datetime, "error_action" => "abort", "priority" => 100, "status" => "I"}
  iex> {:ok, new_job_schedule} = MateriaBatch.JobSchedules.create_job_schedule(params)
  iex> {:ok, deleted_job_schedule} = MateriaBatch.JobSchedules.delete_job_schedule(new_job_schedule)
  iex> MateriaBatch.JobSchedules.list_job_schedules_by_params(%{"and" => [], "or" => [%{"job_code" => "delete_job_schedule_test001"}]})
  []

  """
  def delete_job_schedule(%JobSchedule{} = job_schedule) do
    @repo.delete(job_schedule)
  end

  def list_job_schedules_by_params(params) do
    @repo
    |> EctoUtil.select_by_param(JobSchedule, params)
  end

  @doc """

  iex> now_datetime = MateriaUtils.Calendar.CalendarUtil.now()
  iex> executable_jobs = MateriaBatch.JobSchedules.list_executable_jobs(now_datetime, 1)
  iex> length(executable_jobs)
  1
  """
  def list_executable_jobs(base_datetime, limit) do

    JobSchedule
    |> where([s], s.next_check_datetime <= ^base_datetime )
    |> where([s], s.status == ^JobSchedule.status.initial )
    |> order_by([:priority, :schedule_datetime, :job_code])
    |> limit(^limit)
    |> lock("FOR UPDATE")
    |> @repo.all()

  end

  @doc """

  iex> running_jobs = MateriaBatch.JobSchedules.list_running_jobs()
  iex> length(running_jobs)
  2

  """
  def list_running_jobs() do
    JobSchedule
    |> where([s], s.status == ^JobSchedule.status.running )
    |> order_by([:start_datetime])
    |> lock("FOR UPDATE")
    |> @repo.all()
  end

end
