defmodule MateriaBatch.BatchJobs.TableSweeper do

  alias MateriBatch.BatchJobs.BatchJobBase

  alias MateriaUtils.Ecto.EctoUtil

  alias MateriaUtils.Calendar.CalendarUtil

  require Logger

  def run(schema_string, base_datetime_column_string, saving_days, params) do

    Logger.debug("#{__MODULE__} run start.")

    schema = String.to_existing_atom("Elixir." <> schema_string)
    base_datetime = CalendarUtil.now()
    base_datetime_column = String.to_atom(base_datetime_column_string)
    {:ok, result} = BatchJobBase.single_transaction(__MODULE__, :sweep, [schema, base_datetime_column, base_datetime, saving_days, params])

    Logger.debug("#{__MODULE__} run end.")
    {:ok, result}

  end

  def sweep(_result, schema, base_datetime_column, base_datetime, saving_days, params) do

    Logger.info("#{__MODULE__} sweep start. schema:#{inspect(schema)} base_datetime:#{inspect(base_datetime)} saving_days:#{saving_days}")

    repo =  Application.get_env(:materia, :repo)

    delete_base_datetime = Timex.shift(base_datetime, days: - saving_days)
    {count, result_message} = EctoUtil.delete_by_param(repo, schema, base_datetime_column, delete_base_datetime, params)

    Logger.info("#{__MODULE__} sweep end. delete count: #{count}")
    {:ok, "delete_count: #{count} result_message: #{inspect(result_message)}" }

  end

end
