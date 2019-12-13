defmodule MateriaBatch.JobMasters do
  @moduledoc """
  The JobMasters context.
  """

  import Ecto.Query, warn: false

  alias MateriaBatch.JobMasters.JobMaster
  alias MateriaUtils.Ecto.EctoUtil

  @repo Application.get_env(:materia, :repo)

  @doc """
  Returns the list of job_mst.

  ## Examples

      iex> list_job_mst()
      [%JobMaster{}, ...]

  """
  def list_job_mst do
    @repo.all(JobMaster)
  end

  @doc """
  Gets a single job_master.

  Raises `Ecto.NoResultsError` if the Job master does not exist.

  ## Examples

      iex> get_job_master!(123)
      %JobMaster{}

      iex> get_job_master!(456)
      ** (Ecto.NoResultsError)

  """
  def get_job_master!(id), do: @repo.get!(JobMaster, id)

  @doc """
  Creates a job_master.

  ## Examples

      iex> create_job_master(%{field: value})
      {:ok, %JobMaster{}}

      iex> create_job_master(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_job_master(attrs \\ %{}) do
    %JobMaster{}
    |> JobMaster.create_changeset(attrs)
    |> @repo.insert()
  end

  @doc """
  Updates a job_master.

  ## Examples

      iex> update_job_master(job_master, %{field: new_value})
      {:ok, %JobMaster{}}

      iex> update_job_master(job_master, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_job_master(%JobMaster{} = job_master, attrs) do
    job_master
    |> JobMaster.update_changeset(attrs)
    |> @repo.update()
  end

  @doc """
  Deletes a JobMaster.

  ## Examples

      iex> delete_job_master(job_master)
      {:ok, %JobMaster{}}

      iex> delete_job_master(job_master)
      {:error, %Ecto.Changeset{}}

  """
  def delete_job_master(%JobMaster{} = job_master) do
    @repo.delete(job_master)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking job_master changes.

  ## Examples

      iex> change_job_master(job_master)
      %Ecto.Changeset{source: %JobMaster{}}

  """
  def change_job_master(%JobMaster{} = job_master) do
    JobMaster.create_changeset(job_master, %{})
  end

  def list_job_masters_by_params(params) do
    @repo
    |> EctoUtil.select_by_param(JobMaster, params)
  end
end
