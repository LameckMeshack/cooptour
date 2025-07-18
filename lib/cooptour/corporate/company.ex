defmodule Cooptour.Corporate.Company do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cooptour.Accounts.User
  alias Cooptour.Corporate.{Address, Branch}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "companies" do
    field :name, :string
    field :logo, :string
    field :contact_email, :string
    field :contact_phone, :string

    embeds_one :address, Address, on_replace: :update
    belongs_to :user, User, type: :binary_id
    has_many :branches, Branch, foreign_key: :company_id
    field :is_active, :boolean, default: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(company, attrs, user_scope) do
    company
    |> cast(attrs, [:name, :logo, :contact_email, :contact_phone])
    |> validate_required([:name, :logo, :contact_email, :contact_phone])
    |> cast_embed(:address, with: &Address.changeset/2, required: true)
    |> put_change(:user_id, user_scope.user.id)
  end
end
