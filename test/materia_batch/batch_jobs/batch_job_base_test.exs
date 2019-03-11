defmodule MateriaBatch.BatchJobBaseTest do

  use MateriaBatch.DataCase

  alias MateriBatch.BatchJobs.BatchJobBase
  alias MateriaBatch.BatchJobs.BatchJobDammy

  describe "error cases" do

    test "error taple case" do

      {:error, result} = BatchJobBase.single_transaction(__MODULE__, :error_taple_batch)
      assert result == "function:error_taple_batch message:\"error tapble batch result\""
    end

    test "exception case" do

      {:error, result} = BatchJobBase.single_transaction(__MODULE__, :exception_occuer_batch)
      assert result == "%RuntimeError{message: \"exception_occer_batch result\"}"
    end

  end

  # function for test
  def error_taple_batch(_reason) do
    {:error, "error tapble batch result"}
  end
  def exception_occuer_batch(_reason) do
    raise RuntimeError, message: "exception_occer_batch result"
  end

end


