defmodule Cognac.Repo.Migrations.AddUrlToProductPrices do
  use Ecto.Migration

  def change do
    alter table(:product_prices) do
      add :url, :string
      remove :page_id
    end
  end
end
