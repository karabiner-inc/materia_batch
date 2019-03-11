defmodule MateriaBatchWeb.JobMasterView do
  use MateriaBatchWeb, :view
  alias MateriaBatchWeb.JobMasterView

  def render("index.json", %{job_mst: job_mst}) do
    render_many(job_mst, JobMasterView, "job_master.json")
  end

  def render("show.json", %{job_master: job_master}) do
    render_one(job_master, JobMasterView, "job_master.json")
  end

  def render("job_master.json", %{job_master: job_master}) do
    %{
      id: job_master.id,
      job_code: job_master.job_code,
      name: job_master.name,
      module: job_master.module,
      function: job_master.function,
      params: job_master.params,
      schedule_time: job_master.schedule_time,
      error_action: job_master.error_action,
      reschedule_period_sec: job_master.reschedule_period_sec,
      priority: job_master.priority,
      schedule_period_type: job_master.schedule_period_type,
      calender_type: job_master.calender_type,
      lock_version: job_master.lock_version,
    }
  end
end
