defmodule Cooptour.Repo.Migrations.CreateCompanies do
  use Ecto.Migration

  def change do
    create table(:companies, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :logo, :string
      add :address, :map
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      # add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:companies, [:user_id])
  end
end
