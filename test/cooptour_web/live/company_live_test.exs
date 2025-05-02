defmodule CooptourWeb.CompanyLiveTest do
  use CooptourWeb.ConnCase

  import Phoenix.LiveViewTest
  import Cooptour.CorporateFixtures

  @create_attrs %{name: "some name", address: %{}, logo: "some logo"}
  @update_attrs %{name: "some updated name", address: %{}, logo: "some updated logo"}
  @invalid_attrs %{name: nil, address: nil, logo: nil}

  setup :register_and_log_in_user

  defp create_company(%{scope: scope}) do
    company = company_fixture(scope)

    %{company: company}
  end

  describe "Index" do
    setup [:create_company]

    test "lists all companies", %{conn: conn, company: company} do
      {:ok, _index_live, html} = live(conn, ~p"/companies")

      assert html =~ "Listing Companies"
      assert html =~ company.name
    end

    test "saves new company", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/companies")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Company")
               |> render_click()
               |> follow_redirect(conn, ~p"/companies/new")

      assert render(form_live) =~ "New Company"

      assert form_live
             |> form("#company-form", company: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#company-form", company: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/companies")

      html = render(index_live)
      assert html =~ "Company created successfully"
      assert html =~ "some name"
    end

    test "updates company in listing", %{conn: conn, company: company} do
      {:ok, index_live, _html} = live(conn, ~p"/companies")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#companies-#{company.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/companies/#{company}/edit")

      assert render(form_live) =~ "Edit Company"

      assert form_live
             |> form("#company-form", company: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#company-form", company: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/companies")

      html = render(index_live)
      assert html =~ "Company updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes company in listing", %{conn: conn, company: company} do
      {:ok, index_live, _html} = live(conn, ~p"/companies")

      assert index_live |> element("#companies-#{company.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#companies-#{company.id}")
    end
  end

  describe "Show" do
    setup [:create_company]

    test "displays company", %{conn: conn, company: company} do
      {:ok, _show_live, html} = live(conn, ~p"/companies/#{company}")

      assert html =~ "Show Company"
      assert html =~ company.name
    end

    test "updates company and returns to show", %{conn: conn, company: company} do
      {:ok, show_live, _html} = live(conn, ~p"/companies/#{company}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/companies/#{company}/edit?return_to=show")

      assert render(form_live) =~ "Edit Company"

      assert form_live
             |> form("#company-form", company: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#company-form", company: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/companies/#{company}")

      html = render(show_live)
      assert html =~ "Company updated successfully"
      assert html =~ "some updated name"
    end
  end
end
