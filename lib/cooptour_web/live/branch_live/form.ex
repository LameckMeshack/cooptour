defmodule CooptourWeb.BranchLive.Form do
  use CooptourWeb, :live_view

  alias Cooptour.Corporate
  alias Cooptour.Corporate.Branch

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage branch records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="branch-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:name]} type="text" label="Name" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Branch</.button>
          <.button navigate={return_path(@current_scope, @return_to, @branch)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"branch_id" => branch_id}) do
    branch = Corporate.get_branch!(socket.assigns.current_scope, branch_id)

    socket
    |> assign(:page_title, "Edit Branch")
    |> assign(:branch, branch)
    |> assign(:form, to_form(Corporate.change_branch(socket.assigns.current_scope, branch)))
  end

  defp apply_action(socket, :new, _params) do
    branch = %Branch{user_id: socket.assigns.current_scope.user.id}

    socket
    |> assign(:page_title, "New Branch")
    |> assign(:branch, branch)
    |> assign(:form, to_form(Corporate.change_branch(socket.assigns.current_scope, branch)))
  end

  @impl true
  def handle_event("validate", %{"branch" => branch_params}, socket) do
    changeset =
      Corporate.change_branch(socket.assigns.current_scope, socket.assigns.branch, branch_params)

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"branch" => branch_params}, socket) do
    save_branch(socket, socket.assigns.live_action, branch_params)
  end

  defp save_branch(socket, :edit, branch_params) do
    case Corporate.update_branch(
           socket.assigns.current_scope,
           socket.assigns.branch,
           branch_params
         ) do
      {:ok, branch} ->
        {:noreply,
         socket
         |> put_flash(:info, "Branch updated successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, branch)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_branch(socket, :new, branch_params) do
    case Corporate.create_branch(socket.assigns.current_scope, branch_params) do
      {:ok, branch} ->
        {:noreply,
         socket
         |> put_flash(:info, "Branch created successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, branch)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path(scope, "index", _branch), do: ~p"/companies/#{scope.company}/branches"
  defp return_path(scope, "show", branch), do: ~p"/companies/#{scope.company}/branches/#{branch}"
end
