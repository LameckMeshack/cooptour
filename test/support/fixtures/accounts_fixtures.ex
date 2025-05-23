defmodule Cooptour.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Cooptour.Accounts` context.
  """

  import Ecto.Query

  alias Cooptour.Accounts
  alias Cooptour.Accounts.Scope

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "Passw0rd!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      first_name: "John",
      last_name: "Doe",
      phone: "1234567890"
    })
  end

  def unconfirmed_user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Accounts.register_user()

    user
  end

  def user_fixture(attrs \\ %{}) do
    user = unconfirmed_user_fixture(attrs)

    token =
      extract_user_token(fn url ->
        Accounts.deliver_login_instructions(user, url)
      end)

    user_with_tkn = %{
      "last_name" => user.last_name,
      "first_name" => user.first_name,
      "token" => token,
      "phone" => user.phone,
      "password" => valid_user_password()
    }

    {:ok, user, _expired_tokens} = Accounts.login_user_by_magic_link(user_with_tkn)

    user
  end

  def user_scope_fixture do
    user = user_fixture()
    user_scope_fixture(user)
  end

  def user_scope_fixture(user) do
    Scope.for_user(user)
  end

  def set_password(user) do
    {:ok, user, _expired_tokens} =
      Accounts.update_user_password(user, %{password: valid_user_password()})

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end

  def override_token_inserted_at(token, inserted_at) when is_binary(token) do
    Cooptour.Repo.update_all(
      from(t in Accounts.UserToken,
        where: t.token == ^token
      ),
      set: [inserted_at: inserted_at]
    )
  end

  def generate_user_magic_link_token(user) do
    {encoded_token, user_token} = Accounts.UserToken.build_email_token(user, "login")
    Cooptour.Repo.insert!(user_token)
    {encoded_token, user_token.token}
  end
end
