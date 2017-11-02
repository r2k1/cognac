defmodule Cognac.Repo.Migrations.CreateProductPrices do
  use Ecto.Migration

  def change do
    create table(:product_prices) do
      add :amount, :decimal, precision: 12, scale: 2
      add :currency, :string, length: 3
      add :in_stock, :boolean
      add :product_id, references(:products, on_delete: :delete_all)
      add :store_id, references(:stores, on_delete: :delete_all)
      add :name, :string
      add :url, :string

      timestamps()
    end

    create index(:product_prices, [:product_id])
  end
end
