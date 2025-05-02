defmodule Cooptour.Corporate.Branch do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cooptour.Corporate.Company
  alias Cooptour.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "branches" do
    field :name, :string
    field :address, :map, default: %{}

    belongs_to :company, Company, type: :binary_id
    belongs_to :user, User, type: :binary_id
    field :is_active, :boolean, default: true


    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(branch, attrs, user_scope) do
    branch
    |> cast(attrs, [:name, :address])
    |> validate_required([:name])
    |> put_change(:user_id, user_scope.user.id)
  end
end
