defmodule CooptourWeb.CompanyLive.Index do
  use CooptourWeb, :live_view

  alias Cooptour.Corporate

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Listing Companies
        <:actions>
          <.button variant="primary" navigate={~p"/companies/new"}>
            <.icon name="hero-plus" /> New Company
          </.button>
        </:actions>
      </.header>

      <.table
        id="companies"
        rows={@streams.companies}
        row_click={fn {_id, company} -> JS.navigate(~p"/companies/#{company}") end}
      >
        <:col :let={{_id, company}} label="Name">{company.name}</:col>
        <:col :let={{_id, company}} label="Logo">{company.logo}</:col>
        <:col :let={{_id, company}} label="Address">
          {if company.address != %{} do
            nil
          end}
        </:col>
        <:action :let={{_id, company}}>
          <div class="sr-only">
            <.link navigate={~p"/companies/#{company}"}>Show</.link>
          </div>
          <.link navigate={~p"/companies/#{company}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, company}}>
          <.link
            phx-click={JS.push("delete", value: %{id: company.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    Corporate.subscribe_companies(socket.assigns.current_scope)

    {:ok,
     socket
     |> assign(:page_title, "Listing Companies")
     |> stream(:companies, Corporate.list_companies(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    company = Corporate.get_company!(socket.assigns.current_scope, id)
    {:ok, _} = Corporate.delete_company(socket.assigns.current_scope, company)

    {:noreply, stream_delete(socket, :companies, company)}
  end

  @impl true
  def handle_info({type, %Cooptour.Corporate.Company{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply,
     stream(socket, :companies, Corporate.list_companies(socket.assigns.current_scope),
       reset: true
     )}
  end
end
