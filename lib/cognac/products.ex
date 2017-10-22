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

  @doc """
  Performs a fuzzy search on name field
  """
  @spec find_by_name(binary) :: Product.t | nil
  def find_by_name(name) do
    name = String.downcase(name)
    # TODO: extract levenshtein function
    query = from p in Cognac.Product,
            limit: 1,
            where: fragment("levenshtein(lower(?), ?, 1, 2, 5)", p.name, ^name) < 20,
            order_by: [asc: fragment("levenshtein(lower(?), ?, 1, 2, 5)", p.name, ^name)]
    Cognac.Repo.one(query)
  end
end