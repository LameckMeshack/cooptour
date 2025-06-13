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
    # //convert field address to map

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

  alias Cooptour.Corporate.Branch
  alias Cooptour.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any branch changes.

  The broadcasted messages match the pattern:

    * {:created, %Branch{}}
    * {:updated, %Branch{}}
    * {:deleted, %Branch{}}

  """
  def subscribe_branches(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(Cooptour.PubSub, "user:#{key}:branches")
  end

  defp broadcast_branch(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(Cooptour.PubSub, "user:#{key}:branches", message)
  end

  @doc """
  Returns the list of branches.

  ## Examples

      iex> list_branches(scope)
      [%Branch{}, ...]

  """
  def list_branches(%Scope{} = scope) do
    Repo.all(from branch in Branch, where: branch.user_id == ^scope.user.id)
  end

  @doc """
  Gets a single branch.

  Raises `Ecto.NoResultsError` if the Branch does not exist.

  ## Examples

      iex> get_branch!(123)
      %Branch{}

      iex> get_branch!(456)
      ** (Ecto.NoResultsError)

  """
  def get_branch!(%Scope{} = scope, id) do
    Repo.get_by!(Branch, id: id, user_id: scope.user.id)
  end

  @doc """
  Creates a branch.

  ## Examples

      iex> create_branch(%{field: value})
      {:ok, %Branch{}}

      iex> create_branch(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_branch(%Scope{} = scope, attrs \\ %{}) do
    with {:ok, branch = %Branch{}} <-
           %Branch{}
           |> Branch.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast_branch(scope, {:created, branch})
      {:ok, branch}
    end
  end

  @doc """
  Updates a branch.

  ## Examples

      iex> update_branch(branch, %{field: new_value})
      {:ok, %Branch{}}

      iex> update_branch(branch, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_branch(%Scope{} = scope, %Branch{} = branch, attrs) do
    true = branch.user_id == scope.user.id

    with {:ok, branch = %Branch{}} <-
           branch
           |> Branch.changeset(attrs, scope)
           |> Repo.update() do
      broadcast_branch(scope, {:updated, branch})
      {:ok, branch}
    end
  end

  @doc """
  Deletes a branch.

  ## Examples

      iex> delete_branch(branch)
      {:ok, %Branch{}}

      iex> delete_branch(branch)
      {:error, %Ecto.Changeset{}}

  """
  def delete_branch(%Scope{} = scope, %Branch{} = branch) do
    true = branch.user_id == scope.user.id

    with {:ok, branch = %Branch{}} <-
           Repo.delete(branch) do
      broadcast_branch(scope, {:deleted, branch})
      {:ok, branch}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking branch changes.

  ## Examples

      iex> change_branch(branch)
      %Ecto.Changeset{data: %Branch{}}

  """
  def change_branch(%Scope{} = scope, %Branch{} = branch, attrs \\ %{}) do
    true = branch.user_id == scope.user.id

    Branch.changeset(branch, attrs, scope)
  end
end
