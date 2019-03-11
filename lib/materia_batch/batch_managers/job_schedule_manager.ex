defmodule MateriaBatch.BatchManagers.JobScheduleManager do

  use GenServer
  alias MateriaUtils.Calendar.CalendarUtil
  alias MateriaBatch.JobSchedules
  alias MateriaBatch.JobSchedules.JobSchedule
  alias MateriaBatch.BatchManagers.JobExecuter

  alias MateriBatch.BatchJobs.BatchJobBase

  alias MateriaBatch.JobMasters

  require Logger

  @default_job_check_interval 60000

  def init(state) do
    Logger.debug("#{__MODULE__} init start. state:#{inspect(state)}")
    {:ok, schedule_next_check(self(), state)}
  end

  def schedule_next_check(pid, state) do
    Logger.debug("#{__MODULE__} schedule_next_check start. pid:#{inspect(pid)} state:#{inspect(state)}")
    timer = Process.send_after(pid, :check_job, state[:job_check_interval])
    Map.merge(state, %{timer: timer})
  end

  @doc """
  MateriaBatch.JobSchedules.JobScheduleManager.start_link([])
  """
  def start_link(opts \\ []) do
    Logger.debug("#{__MODULE__} start_link start. opts:#{inspect(opts)}")
    configs = Application.get_env(:materia_batch, MateriaBatch.JobSchedules.JobScheduleManager)
    job_check_interval =
      if configs[:job_check_interval] == nil do
        @default_job_check_interval
      else
        configs[:job_check_interval]
      end
    defaults = %{
      job_check_interval: job_check_interval
    }

    state = Enum.into(opts, defaults)
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def handle_info(:check_job, state) do
    {:noreply, check_job(self(), state)}
  end

  def handle_call(:check_job, _from, state) do
    Logger.debug("#{__MODULE__} handle_call start. :check_job state:#{inspect(state)}")
    {:reply, :ok, check_job(self(), state)}
  end

  def check_job(pid, state) do
    Logger.debug("#{__MODULE__} check_job start. pid:#{inspect(pid)} state:#{inspect(state)}")
    base_datetime = CalendarUtil.now()
    check_job_and_execute(base_datetime, state)
    schedule_next_check(pid, state)
  end

  def check_job_and_execute(base_datetime, state) do
    Logger.debug("#{__MODULE__} check_job_by_base_datetime start. base_datetime:#{inspect(base_datetime)}")

    # 環境変数からジョブのMAX並行実行数を取得する

    # 実行中JOBの一覧を取得
    running_job_count = JobSchedules.list_running_jobs()
    |> Enum.count()

    configs = Application.get_env(:materia_batch, MateriaBatch.JobSchedules.JobScheduleManager)
    max_concurrent_jobs = configs[:max_concurrent_jobs]

    runnable_limmit = max_concurrent_jobs - running_job_count

    if runnable_limmit > 0 do

      now_datetime = CalendarUtil.now()
      executable_jobs = JobSchedules.list_executable_jobs(now_datetime, runnable_limmit)

      # jobを実行
      # JobExecuter.start_link()

      # ステータスを実行中に更新
       executable_jobs
       |> Enum.map(fn(job) ->
        #JobExecuter.start(job.job_code)
        JobSchedules.update_job_schedule(job, %{status: JobSchedule.status.running})
        spawn_link(JobExecuter, :execute_job, [job, state])
        #JobExecuter.execute_job(job)
      end)

    end

  end

  def create_job_schedules(schedule_after_day, schedule_period_type) do

    BatchJobBase.single_transaction(__MODULE__, :create_job_schedules, [schedule_after_day, schedule_period_type])

  end

  def create_job_schedules(_result, schedule_after_day, schedule_period_type) do
    Logger.debug("#{__MODULE__} create_job_schedules start.")
    configs = Application.get_env(:materia_batch, MateriaBatch.JobSchedules.JobScheduleManager)
    get_today_module = configs[:get_today_module]
    date_today_function = configs[:date_today_function]
    today =
      if get_today_module == nil or date_today_function == nil do
        CalendarUtil.today()
      else
        apply(get_today_module, date_today_function, [])
      end
    schedule_date = Timex.shift(today, days: schedule_after_day)
    {:ok, schedule_date_str} = Timex.format(schedule_date, "{YYYY}-{0M}-{0D}")

    Logger.debug("#{__MODULE__} create_job_schedules debug005.")

    params = %{"and" => [%{"schedule_period_type" => schedule_period_type}], "or" => []}
    job_masters = JobMasters.list_job_masters_by_params(params)


    job_schedules = job_masters
    |> Enum.map(fn(job_mst) ->
      schedule_datetime_str = schedule_date_str <> "T" <> job_mst.schedule_time <> "Z"
      {:ok, schedule_datetime} = Timex.parse(schedule_datetime_str, "{ISO:Extended}")
      job_schedule_params = %{
        job_code: job_mst.job_code,
        name: job_mst.name,
        module: job_mst.module,
        function: job_mst.function,
        params: job_mst.params,
        priority: job_mst.priority,
        schedule_datetime: schedule_datetime,
        next_check_datetime: schedule_datetime,
        error_action: job_mst.error_action,
        reschedule_period_sec: job_mst.reschedule_period_sec,
        status: JobSchedule.status.initial,
      }
      {:ok, job_schedule} = JobSchedules.create_job_schedule(job_schedule_params)
      job_schedule
    end)

    Logger.debug("#{__MODULE__} create_job_schedules debug010.")

    {:ok, job_schedules}

  end

end

