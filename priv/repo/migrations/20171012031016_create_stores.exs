defmodule Cognac.Repo.Migrations.CreateStores do
  use Ecto.Migration

  def change do
    create table(:stores) do
      add :name, :string
      add :host, :string
      add :home_page, :string

      timestamps()
    end

  end
end
