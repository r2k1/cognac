defmodule Cognac.Product.Price do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cognac.Product.Price
  @type t :: %__MODULE__{}

  schema "product_prices" do
    field :amount, :decimal
    field :currency, :string
    field :name, :string
    field :url, :string
    field :in_stock, :boolean
    belongs_to :product, Cognac.Product
    belongs_to :store, Cognac.Store
    timestamps()
  end

  @doc false
  def changeset(%Price{} = price, attrs) do
    price
    |> cast(attrs, [:amount, :currency, :url, :name, :in_stock, :store_id])
    |> validate_required([:amount, :currency, :url, :name, :store_id])
  end
end
