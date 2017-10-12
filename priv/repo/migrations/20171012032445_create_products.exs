defmodule Cognac.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :model_number, :string
      add :image_url, :string
      add :body, :string

      timestamps()
    end

  end
end
