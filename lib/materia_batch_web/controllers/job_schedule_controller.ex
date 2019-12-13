defmodule MateriaBatchWeb.JobScheduleController do
  use MateriaBatchWeb, :controller

  alias MateriaBatch.JobSchedules
  alias MateriaBatch.JobSchedules.JobSchedule

  action_fallback(MateriaBatchWeb.FallbackController)

  def index(conn, _params) do
    job_schedules = JobSchedules.list_job_schedules()
    render(conn, "index.json", job_schedules: job_schedules)
  end

  def create(conn, job_schedule_params) do
    with {:ok, %JobSchedule{} = job_schedule} <- JobSchedules.create_job_schedule(job_schedule_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", job_schedule_path(conn, :show, job_schedule))
      |> render("show.json", job_schedule: job_schedule)
    end
  end

  def show(conn, %{"id" => id}) do
    job_schedule = JobSchedules.get_job_schedule!(id)
    render(conn, "show.json", job_schedule: job_schedule)
  end

  def update(conn, job_schedule_params) do
    job_schedule = JobSchedules.get_job_schedule!(job_schedule_params["id"])

    with {:ok, %JobSchedule{} = job_schedule} <- JobSchedules.update_job_schedule(job_schedule, job_schedule_params) do
      render(conn, "show.json", job_schedule: job_schedule)
    end
  end

  def delete(conn, %{"id" => id}) do
    job_schedule = JobSchedules.get_job_schedule!(id)

    with {:ok, %JobSchedule{}} <- JobSchedules.delete_job_schedule(job_schedule) do
      send_resp(conn, :no_content, "")
    end
  end
end
