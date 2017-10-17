defmodule Cognac.Products do
  @moduledoc """
  The Products context.
  """

  import Ecto.Query, warn: false
  alias Cognac.Repo

  alias Cognac.Product

  @doc """
  Returns the list of products.
  """
  def list_products do
    Repo.all(Product)
  end

  def get_product!(id) do
    Product
    |> Repo.get!(id)
    |> Repo.preload(:prices)
  end

  def insert_or_update_product(attrs) do
    query = from p in Cognac.Product, where: p.name == ^attrs.name
    product = Cognac.Repo.one(query) || %Cognac.Product{}    
    changeset = Cognac.Product.changeset(product, attrs)
    Cognac.Repo.insert_or_update!(changeset)
  end
end