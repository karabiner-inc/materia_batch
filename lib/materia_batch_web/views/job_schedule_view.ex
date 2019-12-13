defmodule MateriaBatchWeb.JobScheduleView do
  use MateriaBatchWeb, :view
  alias MateriaBatchWeb.JobScheduleView

  def render("index.json", %{job_schedules: job_schedules}) do
    render_many(job_schedules, JobScheduleView, "job_schedule.json")
  end

  def render("show.json", %{job_schedule: job_schedule}) do
    render_one(job_schedule, JobScheduleView, "job_schedule.json")
  end

  def render("job_schedule.json", %{job_schedule: job_schedule}) do
    %{
      id: job_schedule.id,
      job_code: job_schedule.job_code,
      name: job_schedule.name,
      module: job_schedule.module,
      function: job_schedule.function,
      params: job_schedule.params,
      schedule_datetime: job_schedule.schedule_datetime,
      next_check_datetime: job_schedule.next_check_datetime,
      error_action: job_schedule.error_action,
      reschedule_period_sec: job_schedule.reschedule_period_sec,
      priority: job_schedule.priority,
      status: job_schedule.status,
      start_datetime: job_schedule.start_datetime,
      end_datetime: job_schedule.end_datetime,
      result: job_schedule.result,
      lock_version: job_schedule.lock_version
    }
  end
end
