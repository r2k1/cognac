defmodule Cognac.Repo.Migrations.CreatePages do
  use Ecto.Migration

  def change do
    create table(:pages) do
      add :url, :string
      add :status_code, :integer
      add :visited_at, :naive_datetime
      add :store_id, references(:stores, on_delete: :nothing)

      timestamps()
    end
  end
end
