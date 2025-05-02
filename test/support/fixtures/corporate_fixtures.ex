defmodule Cooptour.CorporateFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Cooptour.Corporate` context.
  """

  @doc """
  Generate a company.
  """
  def company_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        address: %{},
        logo: "some logo",
        name: "some name"
      })

    {:ok, company} = Cooptour.Corporate.create_company(scope, attrs)
    company
  end

  @doc """
  Generate a branch.
  """
  def branch_fixture(scope, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        address: %{},
        name: "some name"
      })

    {:ok, branch} = Cooptour.Corporate.create_branch(scope, attrs)
    branch
  end
end
