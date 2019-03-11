defmodule MateriBatch.BatchJobs.BatchJobBase do

  alias Ecto.Multi
  require Logger

  def single_transaction(module, function_atom, attr \\ []) do
    repo = Application.get_env(:materia, :repo)
    Logger.debug("#{__MODULE__} single_transaction start. repo:#{inspect(repo)}")

    try do
      with {:ok, result} <- Multi.new
      |> Multi.run(function_atom, module, function_atom, attr)
      |> repo.transaction() do
        {:ok, result}
      else
        {:error, function, message, _result} ->
          Logger.error("#{__MODULE__} single_transaction. Ecto.Multi transaction was failed.")
          Logger.info("-------------- failed reason ---------------------------------")
          Logger.info("function:#{function} message:#{inspect(message)}")
          {:error, "function:#{function} message:#{inspect(message)}"}
      end
    rescue
      e ->
        Logger.error("#{__MODULE__} single_transaction. exception occured.")
        Logger.info("-------------- origianl exception ---------------------------------")
        Logger.info("#{inspect(e)}")
        Logger.info("#{Exception.format_stacktrace(System.stacktrace())}")
        {:error, "#{inspect(e)}"}
    end

  end

end
