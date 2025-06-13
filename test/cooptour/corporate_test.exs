defmodule Cooptour.CorporateTest do
  use Cooptour.DataCase

  alias Cooptour.Corporate

  describe "companies" do
    alias Cooptour.Corporate.Company

    import Cooptour.AccountsFixtures, only: [user_scope_fixture: 0]
    import Cooptour.CorporateFixtures

    @invalid_attrs %{name: nil, address: nil, logo: nil}

    test "list_companies/1 returns all scoped companies" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      company = company_fixture(scope)
      other_company = company_fixture(other_scope)
      assert Corporate.list_companies(scope) == [company]
      assert Corporate.list_companies(other_scope) == [other_company]
    end

    test "get_company!/2 returns the company with given id" do
      scope = user_scope_fixture()
      company = company_fixture(scope)
      other_scope = user_scope_fixture()
      assert Corporate.get_company!(scope, company.id) == company
      assert_raise Ecto.NoResultsError, fn -> Corporate.get_company!(other_scope, company.id) end
    end

    test "create_company/2 with valid data creates a company" do
      valid_attrs = %{name: "some name", address: %{}, logo: "some logo"}
      scope = user_scope_fixture()

      assert {:ok, %Company{} = company} = Corporate.create_company(scope, valid_attrs)
      assert company.name == "some name"
      assert company.address == %{}
      assert company.logo == "some logo"
      assert company.user_id == scope.user.id
    end

    test "create_company/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Corporate.create_company(scope, @invalid_attrs)
    end

    test "update_company/3 with valid data updates the company" do
      scope = user_scope_fixture()
      company = company_fixture(scope)
      update_attrs = %{name: "some updated name", address: %{}, logo: "some updated logo"}

      assert {:ok, %Company{} = company} = Corporate.update_company(scope, company, update_attrs)
      assert company.name == "some updated name"
      assert company.address == %{}
      assert company.logo == "some updated logo"
    end

    test "update_company/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      company = company_fixture(scope)

      assert_raise MatchError, fn ->
        Corporate.update_company(other_scope, company, %{})
      end
    end

    test "update_company/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      company = company_fixture(scope)

      assert {:error, %Ecto.Changeset{}} =
               Corporate.update_company(scope, company, @invalid_attrs)

      assert company == Corporate.get_company!(scope, company.id)
    end

    test "delete_company/2 deletes the company" do
      scope = user_scope_fixture()
      company = company_fixture(scope)
      assert {:ok, %Company{}} = Corporate.delete_company(scope, company)
      assert_raise Ecto.NoResultsError, fn -> Corporate.get_company!(scope, company.id) end
    end

    test "delete_company/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      company = company_fixture(scope)
      assert_raise MatchError, fn -> Corporate.delete_company(other_scope, company) end
    end

    test "change_company/2 returns a company changeset" do
      scope = user_scope_fixture()
      company = company_fixture(scope)
      assert %Ecto.Changeset{} = Corporate.change_company(scope, company)
    end
  end

  describe "branches" do
    alias Cooptour.Corporate.Branch

    import Cooptour.AccountsFixtures, only: [user_scope_fixture: 0]
    import Cooptour.CorporateFixtures

    @invalid_attrs %{name: nil, address: nil}

    test "list_branches/1 returns all scoped branches" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      branch = branch_fixture(scope)
      other_branch = branch_fixture(other_scope)
      assert Corporate.list_branches(scope) == [branch]
      assert Corporate.list_branches(other_scope) == [other_branch]
    end

    test "get_branch!/2 returns the branch with given id" do
      scope = user_scope_fixture()
      branch = branch_fixture(scope)
      other_scope = user_scope_fixture()
      assert Corporate.get_branch!(scope, branch.id) == branch
      assert_raise Ecto.NoResultsError, fn -> Corporate.get_branch!(other_scope, branch.id) end
    end

    test "create_branch/2 with valid data creates a branch" do
      valid_attrs = %{name: "some name", address: %{}}
      scope = user_scope_fixture()

      assert {:ok, %Branch{} = branch} = Corporate.create_branch(scope, valid_attrs)
      assert branch.name == "some name"
      assert branch.address == %{}
      assert branch.user_id == scope.user.id
    end

    test "create_branch/2 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      assert {:error, %Ecto.Changeset{}} = Corporate.create_branch(scope, @invalid_attrs)
    end

    test "update_branch/3 with valid data updates the branch" do
      scope = user_scope_fixture()
      branch = branch_fixture(scope)
      update_attrs = %{name: "some updated name", address: %{}}

      assert {:ok, %Branch{} = branch} = Corporate.update_branch(scope, branch, update_attrs)
      assert branch.name == "some updated name"
      assert branch.address == %{}
    end

    test "update_branch/3 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      branch = branch_fixture(scope)

      assert_raise MatchError, fn ->
        Corporate.update_branch(other_scope, branch, %{})
      end
    end

    test "update_branch/3 with invalid data returns error changeset" do
      scope = user_scope_fixture()
      branch = branch_fixture(scope)
      assert {:error, %Ecto.Changeset{}} = Corporate.update_branch(scope, branch, @invalid_attrs)
      assert branch == Corporate.get_branch!(scope, branch.id)
    end

    test "delete_branch/2 deletes the branch" do
      scope = user_scope_fixture()
      branch = branch_fixture(scope)
      assert {:ok, %Branch{}} = Corporate.delete_branch(scope, branch)
      assert_raise Ecto.NoResultsError, fn -> Corporate.get_branch!(scope, branch.id) end
    end

    test "delete_branch/2 with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      branch = branch_fixture(scope)
      assert_raise MatchError, fn -> Corporate.delete_branch(other_scope, branch) end
    end

    test "change_branch/2 returns a branch changeset" do
      scope = user_scope_fixture()
      branch = branch_fixture(scope)
      assert %Ecto.Changeset{} = Corporate.change_branch(scope, branch)
    end
  end
end
