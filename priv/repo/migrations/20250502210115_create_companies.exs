defmodule Cooptour.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :logo, :string
      add :address, :map
      add :contact_email, :string
      add :contact_phone, :string
      add :is_active, :boolean, default: true

      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:companies, [:user_id])
    create unique_index(:companies, [:name])
  end
end
