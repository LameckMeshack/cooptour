defmodule CooptourWeb.BranchLiveTest do
  use CooptourWeb.ConnCase

  import Phoenix.LiveViewTest
  import Cooptour.CorporateFixtures

  @create_attrs %{name: "some name", address: %{}}
  @update_attrs %{name: "some updated name", address: %{}}
  @invalid_attrs %{name: nil, address: nil}

  setup :register_and_log_in_user

  defp create_branch(%{scope: scope}) do
    branch = branch_fixture(scope)

    %{branch: branch}
  end

  describe "Index" do
    setup [:create_branch]

    test "lists all branches", %{conn: conn, branch: branch} do
      {:ok, _index_live, html} = live(conn, ~p"/branches")

      assert html =~ "Listing Branches"
      assert html =~ branch.name
    end

    test "saves new branch", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/branches")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Branch")
               |> render_click()
               |> follow_redirect(conn, ~p"/branches/new")

      assert render(form_live) =~ "New Branch"

      assert form_live
             |> form("#branch-form", branch: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#branch-form", branch: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/branches")

      html = render(index_live)
      assert html =~ "Branch created successfully"
      assert html =~ "some name"
    end

    test "updates branch in listing", %{conn: conn, branch: branch} do
      {:ok, index_live, _html} = live(conn, ~p"/branches")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#branches-#{branch.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/branches/#{branch}/edit")

      assert render(form_live) =~ "Edit Branch"

      assert form_live
             |> form("#branch-form", branch: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#branch-form", branch: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/branches")

      html = render(index_live)
      assert html =~ "Branch updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes branch in listing", %{conn: conn, branch: branch} do
      {:ok, index_live, _html} = live(conn, ~p"/branches")

      assert index_live |> element("#branches-#{branch.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#branches-#{branch.id}")
    end
  end

  describe "Show" do
    setup [:create_branch]

    test "displays branch", %{conn: conn, branch: branch} do
      {:ok, _show_live, html} = live(conn, ~p"/branches/#{branch}")

      assert html =~ "Show Branch"
      assert html =~ branch.name
    end

    test "updates branch and returns to show", %{conn: conn, branch: branch} do
      {:ok, show_live, _html} = live(conn, ~p"/branches/#{branch}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/branches/#{branch}/edit?return_to=show")

      assert render(form_live) =~ "Edit Branch"

      assert form_live
             |> form("#branch-form", branch: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#branch-form", branch: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/branches/#{branch}")

      html = render(show_live)
      assert html =~ "Branch updated successfully"
      assert html =~ "some updated name"
    end
  end
end
