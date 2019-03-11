defmodule MateriaBatch.JobSchedules.JobSchedule do
  use Ecto.Schema
  import Ecto.Changeset


  schema "job_schedules" do
    field :end_datetime, :utc_datetime
    field :error_action, :string
    field :function, :string
    field :job_code, :string
    field :module, :string
    field :name, :string
    field :next_check_datetime, :utc_datetime
    field :params, :string
    field :priority, :integer
    field :reschedule_period_sec, :integer
    field :schedule_datetime, :utc_datetime
    field :start_datetime, :utc_datetime
    field :status, :string
    field :result, :string
    field :lock_version, :integer, default: 0

    timestamps()
  end

  @doc false
  def create_changeset(job_schedule, attrs) do
    job_schedule
    |> cast(attrs, [:job_code, :name, :module, :function, :params, :schedule_datetime, :next_check_datetime, :error_action, :reschedule_period_sec, :priority, :status, :start_datetime, :end_datetime, :result, :lock_version])
    |> validate_required([:job_code, :module, :function, :schedule_datetime, :next_check_datetime, :error_action, :priority, :status])
  end

  @doc false
  def update_changeset(job_schedule, attrs) do
    job_schedule
    |> cast(attrs, [:job_code, :name, :module, :function, :params, :schedule_datetime, :next_check_datetime, :error_action, :reschedule_period_sec, :priority, :status, :start_datetime, :end_datetime, :result, :lock_version])
    |> validate_required(:lock_version)
    |> optimistic_lock(:lock_version)
  end

  def status() do
    %{
      initial: "I", # 初期状態
      running: "R", # 実行中
      success: "S", # 正常終了
      error: "E", # 異常終了
      pause: "P", # 中断
    }
  end
end
