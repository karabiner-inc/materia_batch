defmodule MateriaBatch.JobMasters.JobMaster do
  use Ecto.Schema
  import Ecto.Changeset

  schema "job_mst" do
    field(:calender_type, :string)
    field(:error_action, :string)
    field(:function, :string)
    field(:job_code, :string)
    field(:module, :string)
    field(:name, :string)
    field(:params, :string)
    field(:priority, :integer)
    field(:reschedule_period_sec, :integer)
    field(:schedule_period_type, :string)
    field(:schedule_time, :string)
    field(:lock_version, :integer, default: 0)

    timestamps()
  end

  @doc false
  def create_changeset(job_master, attrs) do
    job_master
    |> cast(attrs, [
      :job_code,
      :name,
      :module,
      :function,
      :params,
      :schedule_time,
      :error_action,
      :reschedule_period_sec,
      :priority,
      :schedule_period_type,
      :calender_type,
      :lock_version
    ])
    |> validate_required([
      :job_code,
      :name,
      :module,
      :function,
      :schedule_time,
      :error_action,
      :reschedule_period_sec,
      :priority,
      :schedule_period_type,
      :calender_type
    ])
    |> unique_constraint(:job_code)
  end

  def update_changeset(job_master, attrs) do
    job_master
    |> cast(attrs, [
      :job_code,
      :name,
      :module,
      :function,
      :params,
      :schedule_time,
      :error_action,
      :reschedule_period_sec,
      :priority,
      :schedule_period_type,
      :calender_type,
      :lock_version
    ])
    |> validate_required(:lock_version)
    |> unique_constraint(:job_code)
    |> optimistic_lock(:lock_version)
  end
end
