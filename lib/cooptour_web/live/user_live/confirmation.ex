defmodule CooptourWeb.UserLive.Confirmation do
  use CooptourWeb, :live_view

  alias Cooptour.Accounts

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="mx-auto max-w-sm">
        <.header class="text-center">Welcome {@user.email}</.header>

        <.form
          :if={!@user.confirmed_at}
          for={@form}
          phx-change="validate"
          id="confirmation_form"
          phx-submit="submit"
          action={~p"/users/log-in?_action=confirmed"}
          phx-trigger-action={@trigger_submit}
          phx-debounce="blur"
        >
          <input type="hidden" name={@form[:token].name} value={@form[:token].value} />
          <.input
            :if={!@current_scope}
            field={@form[:remember_me]}
            type="checkbox"
            label="Keep me logged in"
          />
          <.input field={@form[:first_name]} type="text" label="First Name" phx-mounted={JS.focus()} />
          <.input field={@form[:last_name]} type="text" label="Last Name" />
          <.input field={@form[:phone]} type="tel" label="Phone" />
          <.button variant="primary" phx-disable-with="Confirming..." class="w-full" type="submit">
            Confirm my account
          </.button>
        </.form>

        <.form
          :if={@user.confirmed_at}
          for={@form}
          id="login_form"
          phx-submit="submit"
          action={~p"/users/log-in"}
          phx-trigger-action={@trigger_submit}
        >
          <input type="hidden" name={@form[:token].name} value={@form[:token].value} />
          <.input
            :if={!@current_scope}
            field={@form[:remember_me]}
            type="checkbox"
            label="Keep me logged in"
          />
          <.button variant="primary" phx-disable-with="Logging in..." class="w-full">Log in</.button>
        </.form>

        <p :if={!@user.confirmed_at} class="alert alert-outline mt-8">
          Tip: If you prefer passwords, you can enable them in the user settings.
        </p>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"token" => token}, _session, socket) do
    case Accounts.get_user_by_magic_link_token(token) do
      nil ->
        {:ok,
         socket
         |> put_flash(:error, "Magic link is invalid or it has expired.")
         |> push_navigate(to: ~p"/users/log-in")}

      user ->
        form = create_form(user, token)

        {:ok, assign(socket, user: user, form: form, token: token, trigger_submit: false),
         temporary_assigns: [form: nil]}
    end
  end

  @impl true
  def handle_event(
        "submit",
        %{"user" => %{"remember_me" => remember_me, "token" => token}},
        socket
      ) do
    {:noreply,
     assign(socket,
       form: to_form(%{"token" => token, "remember_me" => remember_me}, as: "user"),
       trigger_submit: true
     )}
  end

  @impl true
  def handle_event("submit", %{"user" => params}, socket) do
    params_with_tkn = Map.put(params, "token", socket.assigns.token)
    changeset = Accounts.user_confirmation_changeset(params_with_tkn)

    if changeset.valid? do
      {:noreply, assign(socket, form: to_form(params_with_tkn, as: "user"), trigger_submit: true)}
    else
      changeset = changeset |> Map.put(:action, :validate)
      {:noreply, assign(socket, form: to_form(changeset, as: "user"))}
    end
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      Accounts.user_confirmation_changeset(user_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset, as: "user"))}
  end

  defp create_form(%{confirmed_at: nil} = _user, token) do
    changeset = Accounts.user_confirmation_changeset(%{"token" => token})
    to_form(changeset, as: "user") |> Map.put(:data, %{"token" => token})
  end

  defp create_form(_user, token) do
    to_form(%{"token" => token}, as: "user")
  end
end
