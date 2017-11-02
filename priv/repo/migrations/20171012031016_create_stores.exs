defmodule Cognac.Repo.Migrations.CreateStores do
  use Ecto.Migration

  def change do
    create table(:stores) do
      add :name, :string
      add :host, :string
      add :homepage, :string, size: 2000

      timestamps()
    end

    create unique_index(:stores, [:host])
    

  end
end
