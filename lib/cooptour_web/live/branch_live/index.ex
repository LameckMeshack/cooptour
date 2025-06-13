defmodule CooptourWeb.BranchLive.Index do
  use CooptourWeb, :live_view

  alias Cooptour.Corporate

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Listing Branches
        <:actions>
          <.button variant="primary" navigate={~p"/companies/#{@current_scope.company}/branches/new"}>
            <.icon name="hero-plus" /> New Branch
          </.button>
        </:actions>
      </.header>

      <.table
        id="branches"
        rows={@streams.branches}
        row_click={fn {_id, branch} -> JS.navigate(~p"/companies/#{@current_scope.company}/branches/#{branch}") end}
      >
        <:col :let={{_id, branch}} label="Name">{branch.name}</:col>
        <:col :let={{_id, branch}} label="Address">
          <%!-- {branch.address} --%>
          {if branch.address != %{} do
            nil
          end}
        </:col>
        <:action :let={{_id, branch}}>
          <div class="sr-only">
            <.link navigate={~p"/companies/#{@current_scope.company}/branches/#{branch}"}>Show</.link>
          </div>
          <.link navigate={~p"/companies/#{@current_scope.company}/branches/#{branch}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, branch}}>
          <.link
            phx-click={JS.push("delete", value: %{id: branch.id}) |> hide("##{id}")}
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
    Corporate.subscribe_branches(socket.assigns.current_scope)

    {:ok,
     socket
     |> assign(:page_title, "Listing Branches")
     |> stream(:branches, Corporate.list_branches(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    branch = Corporate.get_branch!(socket.assigns.current_scope, id)
    {:ok, _} = Corporate.delete_branch(socket.assigns.current_scope, branch)

    {:noreply, stream_delete(socket, :branches, branch)}
  end

  @impl true
  def handle_info({type, %Cooptour.Corporate.Branch{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply,
     stream(socket, :branches, Corporate.list_branches(socket.assigns.current_scope), reset: true)}
  end
end
