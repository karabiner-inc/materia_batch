defmodule MateriaBatch.Repo.Migrations.CreateJobMst do
  use Ecto.Migration

  def change do
    create table(:job_mst) do
      add :job_code, :string
      add :name, :string
      add :module, :string
      add :function, :string
      add :params, :string
      add :schedule_time, :string
      add :error_action, :string
      add :reschedule_period_sec, :integer
      add :priority, :integer
      add :schedule_period_type, :string
      add :calender_type, :string
      add :lock_version, :bigint

      timestamps()
    end

    create unique_index(:job_mst, [:job_code])
    create index(:job_mst, [:priority, :schedule_time, :job_code])

  end
end
