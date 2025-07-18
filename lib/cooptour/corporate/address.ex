defmodule Cooptour.Corporate.Address do
  @moduledoc """
  The Address context.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :street_address, :string, default: ""
    field :street_address_2, :string, default: ""
    field :city, :string, default: ""
    field :state_province, :string, default: ""
    field :postal_code, :string, default: ""
    field :country, :string, default: ""
  end

  def changeset(address, attrs) do
    address
    |> cast(attrs, [
      :street_address,
      :street_address_2,
      :city,
      :state_province,
      :postal_code,
      :country
    ])

    |> validate_required([:street_address, :city, :country])
  end
end
