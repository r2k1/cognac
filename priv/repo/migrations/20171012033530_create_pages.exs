defmodule Cognac.Repo.Migrations.CreatePages do
  use Ecto.Migration

  def change do
    create table(:pages) do
      add :url, :string, size: 2000, null: false
      add :status_code, :integer, null: false
      add :visited_at, :naive_datetime, null: false
      add :body, :text
      add :store_id, references(:stores, on_delete: :nothing)

      timestamps()
    end

    create index(:pages, [:url])
  end
end
