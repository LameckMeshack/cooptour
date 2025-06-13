defmodule CooptourWeb.BranchLive.Show do
  use CooptourWeb, :live_view

  alias Cooptour.Corporate

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Branch {@branch.id}
        <:subtitle>This is a branch record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/branches"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/branches/#{@branch}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit branch
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Name">{@branch.name}</:item>
        <:item title="Address">
          <%!-- {@branch.address} --%>
          {if @branch.address != %{} do
            nil
          end}
        </:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    Corporate.subscribe_branches(socket.assigns.current_scope)

    {:ok,
     socket
     |> assign(:page_title, "Show Branch")
     |> assign(:branch, Corporate.get_branch!(socket.assigns.current_scope, id))}
  end

  @impl true
  def handle_info(
        {:updated, %Cooptour.Corporate.Branch{id: id} = branch},
        %{assigns: %{branch: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :branch, branch)}
  end

  def handle_info(
        {:deleted, %Cooptour.Corporate.Branch{id: id}},
        %{assigns: %{branch: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current branch was deleted.")
     |> push_navigate(to: ~p"/branches")}
  end
end
