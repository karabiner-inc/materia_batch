defmodule MateriaBatchWeb.JobMasterControllerTest do
  use MateriaBatchWeb.ConnCase

  alias MateriaBatch.JobMasters
  alias MateriaBatch.JobMasters.JobMaster

  @create_attrs %{calender_type: "some calender_type", error_action: "some error_action", function: "some function", job_code: "some job_code", module: "some module", name: "some name", params: "some params", priority: 42, reschedule_period_sec: 42, schedule_period_type: "some schedule_period_type", schedule_time: "some schedule_time"}
  @update_attrs %{calender_type: "some updated calender_type", error_action: "some updated error_action", function: "some updated function", job_code: "some updated job_code", module: "some updated module", name: "some updated name", params: "some updated params", priority: 43, reschedule_period_sec: 43, schedule_period_type: "some updated schedule_period_type", schedule_time: "some updated schedule_time"}

  def fixture(:job_master) do
    {:ok, job_master} = JobMasters.create_job_master(@create_attrs)
    job_master
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all job_mst", %{conn: conn} do
      conn = get conn, job_master_path(conn, :index)
      resp = json_response(conn, 200)
      assert  length(resp) == 3
    end
  end

  describe "create job_master" do
    test "renders job_master when data is valid", %{conn: conn} do
      conn = post conn, job_master_path(conn, :create), @create_attrs
      assert %{"id" => id} = json_response(conn, 201)

      conn = get conn, job_master_path(conn, :show, id)
      assert json_response(conn, 200) == %{
        "id" => id,
        "calender_type" => "some calender_type",
        "error_action" => "some error_action",
        "function" => "some function",
        "job_code" => "some job_code",
        "module" => "some module",
        "name" => "some name",
        "params" => "some params",
        "priority" => 42,
        "reschedule_period_sec" => 42,
        "schedule_period_type" => "some schedule_period_type",
        "schedule_time" => "some schedule_time",
        "lock_version" => 0
      }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, job_master_path(conn, :create), @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update job_master" do
    setup [:create_job_master]

    test "renders job_master when data is valid", %{conn: conn, job_master: %JobMaster{id: id} = job_master} do
      conn = put conn, job_master_path(conn, :update, job_master), @update_attrs
      resp = json_response(conn, 200)
      assert %{"id" => ^id, "lock_version" => lock_version} = resp
      assert resp = []

      conn = get conn, job_master_path(conn, :show, id)
      resp = json_response(conn, 200)
      assert resp == %{
        "id" => id,
        "calender_type" => "some updated calender_type",
        "error_action" => "some updated error_action",
        "function" => "some updated function",
        "job_code" => "some updated job_code",
        "module" => "some updated module",
        "name" => "some updated name",
        "params" => "some updated params",
        "priority" => 43,
        "reschedule_period_sec" => 43,
        "schedule_period_type" => "some updated schedule_period_type",
        "schedule_time" => "some updated schedule_time",
        "lock_version" => lock_version
      }
    end
  end

  describe "delete job_master" do
    setup [:create_job_master]

    test "deletes chosen job_master", %{conn: conn, job_master: job_master} do
      conn = delete conn, job_master_path(conn, :delete, job_master)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, job_master_path(conn, :show, job_master)
      end
    end
  end

  defp create_job_master(_) do
    job_master = fixture(:job_master)
    {:ok, job_master: job_master}
  end
end
