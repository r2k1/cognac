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
end