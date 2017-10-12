defmodule Cognac.Product do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cognac.Product


  schema "products" do
    field :body, :string
    field :image_url, :string
    field :model_number, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%Product{} = product, attrs) do
    product
    |> cast(attrs, [:name, :model_number, :image_url, :body])
    |> validate_required([:name, :model_number, :image_url, :body])
  end
end
