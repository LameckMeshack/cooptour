defmodule Cooptour.Corporate.Company do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cooptour.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "companies" do
    field :name, :string
    field :logo, :string
    field :address, :map
    belongs_to :user, User, type: :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(company, attrs, user_scope) do
    company
    |> cast(attrs, [:name, :logo, :address])
    |> validate_required([:name, :logo])
    |> put_change(:user_id, user_scope.user.id)
  end
end
