defmodule MateriaBatchWeb.JobScheduleControllerTest do
  use MateriaBatchWeb.ConnCase

  alias MateriaBatch.JobSchedules
  alias MateriaBatch.JobSchedules.JobSchedule

  @create_attrs %{end_datetime: "2010-04-17 14:00:00.000000Z", error_action: "some error_action", function: "some function", job_code: "some job_code", module: "some module", name: "some name", next_check_datetime: "2010-04-17 14:00:00.000000Z", params: "some params", priority: 42, reschedule_period_sec: 42, schedule_datetime: "2010-04-17 14:00:00.000000Z", start_datetime: "2010-04-17 14:00:00.000000Z", status: "some status", result: "some result"}
  @update_attrs %{end_datetime: "2011-05-18 15:01:01.000000Z", error_action: "some updated error_action", function: "some updated function", job_code: "some updated job_code", module: "some updated module", name: "some updated name", next_check_datetime: "2011-05-18 15:01:01.000000Z", params: "some updated params", priority: 43, reschedule_period_sec: 43, schedule_datetime: "2011-05-18 15:01:01.000000Z", start_datetime: "2011-05-18 15:01:01.000000Z", status: "some updated status", result: "some updated result"}


  def fixture(:job_schedule) do
    {:ok, job_schedule} = JobSchedules.create_job_schedule(@create_attrs)
    job_schedule
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all job_schedules", %{conn: conn} do
      conn = get conn, job_schedule_path(conn, :index)
      resp = json_response(conn, 200)
      assert length(resp) == 10
    end
  end

  describe "create job_schedule" do
    test "renders job_schedule when data is valid", %{conn: conn} do
      conn = post conn, job_schedule_path(conn, :create), @create_attrs
      assert %{"id" => id, "lock_version" => lock_version} = json_response(conn, 201)

      conn = get conn, job_schedule_path(conn, :show, id)
      assert json_response(conn, 200) == %{
        "id" => id,
        "end_datetime" => "2010-04-17T14:00:00.000000Z",
        "error_action" => "some error_action",
        "function" => "some function",
        "job_code" => "some job_code",
        "module" => "some module",
        "name" => "some name",
        "next_check_datetime" => "2010-04-17T14:00:00.000000Z",
        "params" => "some params",
        "priority" => 42,
        "reschedule_period_sec" => 42,
        "schedule_datetime" => "2010-04-17T14:00:00.000000Z",
        "start_datetime" => "2010-04-17T14:00:00.000000Z",
        "status" => "some status",
        "result" => "some result",
        "lock_version" => 0
      }
    end

  end

  describe "update job_schedule" do
    setup [:create_job_schedule]

    test "renders job_schedule when data is valid", %{conn: conn, job_schedule: %JobSchedule{id: id} = job_schedule} do
      conn = put conn, job_schedule_path(conn, :update, job_schedule), @update_attrs
      assert %{"id" => ^id, "lock_version" => lock_version} = json_response(conn, 200)

      conn = get conn, job_schedule_path(conn, :show, id)
      assert json_response(conn, 200) == %{
        "id" => id,
        "end_datetime" => "2011-05-18T15:01:01.000000Z",
        "error_action" => "some updated error_action",
        "function" => "some updated function",
        "job_code" => "some updated job_code",
        "module" => "some updated module",
        "name" => "some updated name",
        "next_check_datetime" => "2011-05-18T15:01:01.000000Z",
        "params" => "some updated params",
        "priority" => 43,
        "reschedule_period_sec" => 43,
        "schedule_datetime" => "2011-05-18T15:01:01.000000Z",
        "start_datetime" => "2011-05-18T15:01:01.000000Z",
        "status" => "some updated status",
        "result" => "some updated result",
        "lock_version" => lock_version
      }
    end

  end

  describe "delete job_schedule" do
    setup [:create_job_schedule]

    test "deletes chosen job_schedule", %{conn: conn, job_schedule: job_schedule} do
      conn = delete conn, job_schedule_path(conn, :delete, job_schedule)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, job_schedule_path(conn, :show, job_schedule)
      end
    end
  end

  defp create_job_schedule(_) do
    job_schedule = fixture(:job_schedule)
    {:ok, job_schedule: job_schedule}
  end
end
