defmodule Cognac.Repo.Migrations.CreateCategory do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string
      add :body, :text

      timestamps()
    end
    flush()

    alter table(:products) do
      add :category_id, references(:categories, on_delete: :nothing)
    end
    flush()

    {:ok, category} = Cognac.Repo.insert(%Cognac.Category{name: "Mobile phones"})
    Cognac.Product
    |> Cognac.Repo.update_all(set: [category_id: category.id])
  end
end
