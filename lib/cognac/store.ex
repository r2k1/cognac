defmodule Cognac.Store do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cognac.Store


  schema "stores" do
    field :host, :string
    field :name, :string
    field :homepage, :string
    has_many :product_prices, Cognac.Product.Price, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(%Store{} = store, attrs) do
    store
    |> cast(attrs, [:name, :host, :homepage])
    |> validate_required([:name, :host, :homepage])
  end
end
