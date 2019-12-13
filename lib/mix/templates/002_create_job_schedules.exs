defmodule MateriaBatch.Repo.Migrations.CreateJobSchedules do
  use Ecto.Migration

  def change do
    create table(:job_schedules) do
      add(:job_code, :string)
      add(:name, :string)
      add(:module, :string)
      add(:function, :string)
      add(:params, :string)
      add(:schedule_datetime, :utc_datetime)
      add(:next_check_datetime, :utc_datetime)
      add(:error_action, :string)
      add(:reschedule_period_sec, :integer)
      add(:priority, :integer)
      add(:status, :string)
      add(:start_datetime, :utc_datetime)
      add(:end_datetime, :utc_datetime)
      add(:result, :string, size: 10000)
      add(:lock_version, :bigint)

      timestamps()
    end

    create(index(:job_schedules, [:job_code, :status, :start_datetime, :end_datetime]))
    create(index(:job_schedules, [:status, :next_check_datetime, :priority]))
  end
end
