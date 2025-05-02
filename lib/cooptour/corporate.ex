defmodule Cooptour.Corporate do
  @moduledoc """
  The Corporate context.
  """

  import Ecto.Query, warn: false
  alias Cooptour.Repo

  alias Cooptour.Corporate.Company
  alias Cooptour.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any company changes.

  The broadcasted messages match the pattern:

    * {:created, %Company{}}
    * {:updated, %Company{}}
    * {:deleted, %Company{}}

  """
  def subscribe_companies(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Cooptour.PubSub, "user:#{key}:companies")
  end

  defp broadcast(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Cooptour.PubSub, "user:#{key}:companies", message)
  end

  @doc """
  Returns the list of companies.

  ## Examples

      iex> list_companies(scope)
      [%Company{}, ...]

  """
  def list_companies(%Scope{} = scope) do
    Repo.all(from company in Company, where: company.user_id == ^scope.user.id)
  end

  @doc """
  Gets a single company.

  Raises `Ecto.NoResultsError` if the Company does not exist.

  ## Examples

      iex> get_company!(123)
      %Company{}

      iex> get_company!(456)
      ** (Ecto.NoResultsError)

  """
  def get_company!(%Scope{} = scope, id) do
    Repo.get_by!(Company, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a company.

  ## Examples

      iex> create_company(%{field: value})
      {:ok, %Company{}}

      iex> create_company(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_company(%Scope{} = scope, attrs \\ %{}) do
    with {:ok, company = %Company{}} <-
           %Company{}
           |> Company.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast(scope, {:created, company})
      {:ok, company}
    end
  end

  @doc """
  Updates a company.

  ## Examples

      iex> update_company(company, %{field: new_value})
      {:ok, %Company{}}

      iex> update_company(company, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_company(%Scope{} = scope, %Company{} = company, attrs) do
    true = company.user_id == scope.user.id

    with {:ok, company = %Company{}} <-
           company
           |> Company.changeset(attrs, scope)
           |> Repo.update() do
      broadcast(scope, {:updated, company})
      {:ok, company}
    end
  end

  @doc """
  Deletes a company.

  ## Examples

      iex> delete_company(company)
      {:ok, %Company{}}

      iex> delete_company(company)
      {:error, %Ecto.Changeset{}}

  """
  def delete_company(%Scope{} = scope, %Company{} = company) do
    true = company.user_id == scope.user.id

    with {:ok, company = %Company{}} <-
           Repo.delete(company) do
      broadcast(scope, {:deleted, company})
      {:ok, company}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking company changes.

  ## Examples

      iex> change_company(company)
      %Ecto.Changeset{data: %Company{}}

  """
  def change_company(%Scope{} = scope, %Company{} = company, attrs \\ %{}) do
    true = company.user_id == scope.user.id

    Company.changeset(company, attrs, scope)
  end
end
