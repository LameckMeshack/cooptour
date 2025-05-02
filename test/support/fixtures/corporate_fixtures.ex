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
end
