defmodule Cognac.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :versions, {:array, :string}
      add :image_url, :string
      add :body, :string
      add :page_id, references(:pages, on_delete: :nilify_all)

      timestamps()
    end

  end
end
