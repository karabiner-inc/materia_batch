defmodule MateriaBatchWeb.JobMasterController do
  use MateriaBatchWeb, :controller

  alias MateriaBatch.JobMasters
  alias MateriaBatch.JobMasters.JobMaster

  action_fallback MateriaBatchWeb.FallbackController

  def index(conn, _params) do
    job_mst = JobMasters.list_job_mst()
    render(conn, "index.json", job_mst: job_mst)
  end

  def create(conn, job_master_params) do
    with {:ok, %JobMaster{} = job_master} <- JobMasters.create_job_master(job_master_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", job_master_path(conn, :show, job_master))
      |> render("show.json", job_master: job_master)
    end
  end

  def show(conn, %{"id" => id}) do
    job_master = JobMasters.get_job_master!(id)
    render(conn, "show.json", job_master: job_master)
  end

  def update(conn, job_master_params) do
    job_master = JobMasters.get_job_master!(job_master_params["id"])

    with {:ok, %JobMaster{} = job_master} <- JobMasters.update_job_master(job_master, job_master_params) do
      render(conn, "show.json", job_master: job_master)
    end
  end

  def delete(conn, %{"id" => id}) do
    job_master = JobMasters.get_job_master!(id)
    with {:ok, %JobMaster{}} <- JobMasters.delete_job_master(job_master) do
      send_resp(conn, :no_content, "")
    end
  end
end
