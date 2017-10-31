defmodule Cognac.Repo.Migrations.AddNameToProductPrice do
  use Ecto.Migration

  def change do
    alter table(:product_prices) do
      add :name, :string
    end
  end
end
