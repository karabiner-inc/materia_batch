defmodule MateriaBatch.BatchManagers.JobExecuter do
  alias MateriaBatch.JobSchedules
  alias MateriaBatch.JobSchedules.JobSchedule
  alias MateriaUtils.Calendar.CalendarUtil

  require Logger

  def execute_job(job_schedule, state) do
    Logger.debug("#{__MODULE__} execute_job start. state:#{inspect(state)} job_schedule:#{inspect(job_schedule)}")

    # 対象ジョブを実行する
    module = String.to_existing_atom("Elixir." <> job_schedule.module)
    function = String.to_atom(job_schedule.function)

    {:ok, params} =
      if job_schedule.params == nil do
        "[]"
      else
        "[ " <> job_schedule.params <> " ]"
      end
      |> Poison.decode()

    Logger.info("#{__MODULE__} execute_job job_code:#{job_schedule.job_code} start.")
    before_job_schedule = JobSchedules.get_job_schedule!(job_schedule.id)

    {:ok, current_job_schedule} =
      JobSchedules.update_job_schedule(before_job_schedule, %{start_datetime: CalendarUtil.now()})

    IO.puts("params:#{inspect(params)}")
    result = apply(module, function, params)
    Logger.info("#{__MODULE__} execute_job job_code:#{job_schedule.job_code} end.#{inspect(result)}")

    # 明示的にエラータプルが返った場合
    updated_job_schedule =
      with {:error, message} <- result do
        Logger.error("#{__MODULE__} execute_job job_code:#{job_schedule.job_code} was finished with error result.")
        Logger.info("-------------- job error message ---------------------------------")
        Logger.info("#{inspect(message)}")

        {:ok, updated_job_schedule} =
          JobSchedules.update_job_schedule(current_job_schedule, %{
            status: JobSchedule.status().error,
            end_datetime: CalendarUtil.now(),
            result: inspect(message)
          })

        updated_job_schedule
      else
        {:ok, ok_result} ->
          Logger.info("#{__MODULE__} execute_job job_code:#{job_schedule.job_code} was finished with ok result.")
          # 明示的にokタプルが返っている場合
          {:ok, updated_job_schedule} =
            JobSchedules.update_job_schedule(current_job_schedule, %{
              status: JobSchedule.status().success,
              end_datetime: CalendarUtil.now(),
              result: inspect(ok_result)
            })

          updated_job_schedule

        _ ->
          # 明示的にOKタプルが返らない場合
          Logger.error("#{__MODULE__} execute_job job_code:#{job_schedule.job_code} was finished with other result.")
          Logger.info("-------------- job result ---------------------------------")
          Logger.info("#{inspect(result)}")

          {:ok, updated_job_schedule} =
            JobSchedules.update_job_schedule(current_job_schedule, %{
              status: JobSchedule.status().error,
              end_datetime: CalendarUtil.now(),
              result: inspect(result)
            })

          updated_job_schedule
      end

    {:noreply, updated_job_schedule}
  end
end
