defmodule MateriaBatch.BatchManagerTest do

  use MateriaBatch.DataCase

  alias MateriaBatch.BatchManagers.JobScheduleManager
  alias MateriaBatch.JobSchedules
  alias MateriaBatch.JobSchedules.JobSchedule
  alias MateriaBatch.BatchManagers.JobExecuter

  describe "job life cycle" do
    @tag timeout: 120000
    test "job create" do
      schedule_after_day = 1
      schedule_period_type = "Daily"

      result = JobScheduleManager.create_job_schedules(schedule_after_day, schedule_period_type)

      # target job was scheduled.
      job_schedules = JobSchedules.list_job_schedules_by_params(%{"and" => [], "or" => [%{"job_code" => "SleepDammy1"}]})
      results = convert_struct2map(job_schedules)

      assert results == [%{end_datetime: nil, error_action: "abort", function: "sleep", job_code: "SleepDammy1", lock_version: 0, module: "Process", name: "スリープダミー１", next_check_datetime: "#DateTime<2019-03-04 09:00:00.000000Z>", params: "500", priority: 100, reschedule_period_sec: 60, result: nil, schedule_datetime: "#DateTime<2019-03-04 09:00:00.000000Z>", start_datetime: nil, status: "I"}]

      job_schedules = JobSchedules.list_job_schedules_by_params(%{"and" => [], "or" => [%{"job_code" => "JobSceduleDailySweep"}]})
      results = convert_struct2map(job_schedules)

      assert results == [%{end_datetime: nil, error_action: "abort", lock_version: 0, next_check_datetime: "#DateTime<2019-03-04 09:00:00.000000Z>", priority: 100, reschedule_period_sec: 60, result: nil, schedule_datetime: "#DateTime<2019-03-04 09:00:00.000000Z>", start_datetime: nil, status: "I", function: "run", job_code: "JobSceduleDailySweep", module: "MateriaBatch.BatchJobs.TableSweeper", name: "ジョブスケジュール日次削除", params: "\"MateriaBatch.JobSchedules.JobSchedule\",\"end_datetime\", 2, {\"and\": [{\"status\": \"S\"}],\"or\": [] }"}]

      # not target job was not scheduled.
      not_target_job_schedules = JobSchedules.list_job_schedules_by_params(%{"and" => [], "or" => [%{"name" => "日次バッチ以外"}]})

      assert not_target_job_schedules == []

      [daily_teble_delete] = job_schedules

      {:noreply, result} = JobExecuter.execute_job(daily_teble_delete, [])
      assert result.status == "S"
      assert result.result == "%{sweep: \"delete_count: 1 result_message: nil\"}"
      job_schedules = JobSchedules.list_job_schedules_by_params(%{"and" => [], "or" => [%{"job_code" => "TEST003"}]})
      assert length(job_schedules) == 0
      job_schedules = JobSchedules.list_job_schedules_by_params(%{"and" => [], "or" => [%{"job_code" => "TEST008"}]})
      assert length(job_schedules) == 1

    end
  end

  describe "job error cases" do
    test "error taple case" do

      [error_job] = JobSchedules.list_job_schedules_by_params(%{"and" => [], "or" => [%{"job_code" => "TEST009"}]})
      {:noreply, result} = JobExecuter.execute_job(error_job, [])
      assert result.result == "{:invalid, \"a\", 0}"


    end

    test "excepton case" do

      try do
      [error_job] = JobSchedules.list_job_schedules_by_params(%{"and" => [], "or" => [%{"job_code" => "TEST004"}]})
      {:noreply, result} = JobExecuter.execute_job(error_job, [])
      # this test case was failed when not occured exception.
      assert true == false
      rescue
        e ->
          IO.inspect(e)
        end
    end

    test "not return ok taple case" do

      [error_job] = JobSchedules.list_job_schedules_by_params(%{"and" => [], "or" => [%{"job_code" => "TEST010"}]})
      {:noreply, result} = JobExecuter.execute_job(error_job, [])
      assert result.status == "E"
    end

  end

  def convert_struct2map(job_schedules) do
    results = job_schedules
    |> Enum.map(fn(job_schedule) ->
      job_schedule
      |> Map.from_struct()
      |> Map.delete(:__meta__)
      |> Map.delete(:inserted_at)
      |> Map.delete(:id)
      |> Map.delete(:updated_at)
      |> Map.replace(:next_check_datetime, inspect(job_schedule.next_check_datetime))
      |> Map.replace(:schedule_datetime, inspect(job_schedule.schedule_datetime))
    end)
  end
end
