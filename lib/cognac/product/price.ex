defmodule Cognac.Product.Price do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cognac.Product.Price


  schema "product_prices" do
    field :amount, :decimal
    field :currency, :string
    field :in_stock, :boolean
    belongs_to :product, Cognac.Product
    belongs_to :store, Cognac.Store
    belongs_to :page, Cognac.Page
    timestamps()
  end

  @doc false
  def changeset(%Price{} = price, attrs) do
    price
    |> cast(attrs, [:amount, :currency, :in_stock])
    |> validate_required([:amount, :currency, :product_id, :store_id, :page_id])
  end
end
