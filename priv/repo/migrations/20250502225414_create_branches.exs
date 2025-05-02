defmodule Cooptour.Repo.Migrations.CreateBranches do
  use Ecto.Migration

  def change do
    create table(:branches, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :address, :map, default: %{}
      add :company_id, references(:companies, on_delete: :nothing, type: :binary_id)
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all)
      add :is_active, :boolean, default: true

      timestamps(type: :utc_datetime)
    end

    create index(:branches, [:company_id])
  end
end
