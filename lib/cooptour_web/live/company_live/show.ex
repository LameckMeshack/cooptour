defmodule CooptourWeb.CompanyLive.Show do
  use CooptourWeb, :live_view

  alias Cooptour.Corporate

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Company {@company.name}
        <:subtitle>This is a company record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/companies"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/companies/#{@company}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit company
          </.button>
          <.button variant="primary" navigate={~p"/companies/#{@company}/branches"}>
            <.icon name="hero-pencil-square" /> Branches
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@company.name}</:item>
        <:item title="Logo">{@company.logo}</:item>
        <:item title="Address">
          <%!-- {@company.address} --%>
          <%= if @company.address != %{} do %>
            nil
          <% end %>
        </:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    Corporate.subscribe_companies(socket.assigns.current_scope)

    {:ok,
     socket
     |> assign(:page_title, "Show Company")
     |> assign(:company, Corporate.get_company!(socket.assigns.current_scope, id))}
  end

  @impl true
  def handle_info(
        {:updated, %Cooptour.Corporate.Company{id: id} = company},
        %{assigns: %{company: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :company, company)}
  end

  def handle_info(
        {:deleted, %Cooptour.Corporate.Company{id: id}},
        %{assigns: %{company: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current company was deleted.")
     |> push_navigate(to: ~p"/companies")}
  end
end
