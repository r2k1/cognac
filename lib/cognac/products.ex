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
    query = from p in Product,
      join: pr in Cognac.Product.Price,
      where: pr.product_id == p.id
    Repo.all(query)
  end

  def get_product!(id) do
    Product
    |> Repo.get!(id)
    |> Repo.preload(:prices)
    |> Repo.preload(prices: :store)
  end

  def insert_or_update_product(attrs) do
    query = from p in Cognac.Product, where: p.name == ^attrs.name
    Cognac.Repo.one(query) || %Cognac.Product{}    
    |> Cognac.Product.changeset(attrs)
    |> Cognac.Repo.insert_or_update!()
  end

  @spec insert_or_update_price(map) :: Cognac.Product.Price.t | nil
  def insert_or_update_price(attrs) do
    case Cognac.Products.find_by_name(attrs.name) do
      nil -> nil
      product ->
        query = from p in Cognac.Product.Price,
          where: p.store_id == ^attrs.store_id and p.product_id == ^product.id
        attrs = Map.merge(attrs, %{ product_id: product.id })
        Cognac.Repo.one(query) || %Cognac.Product.Price{}
        |> Cognac.Product.Price.changeset(attrs)
        |> Cognac.Repo.insert_or_update!()
    end
  end
  
  @doc """
  Performs a fuzzy search on name field
  """
  @spec find_by_name(binary) :: Product.t | nil
  def find_by_name(name) do
    # TODO: extract levenshtein function
    # levenshtein(text source, text target, int ins_cost, int del_cost, int sub_cost) returns int
    query = from p in Cognac.Product,
            limit: 1,
            where: fragment("levenshtein(lower(?), lower(?), 10, 1, 40)", ^name, p.name) < 200,
            order_by: [asc: fragment("levenshtein(lower(?), lower(?), 10, 1, 40)", ^name, p.name)]
    Cognac.Repo.one(query)
  end
end