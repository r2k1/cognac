defmodule Cognac.ProductsTest do
  use ExUnit.Case
  use Cognac.DataCase
  alias Cognac.Product
  alias Cognac.Products

  test "find_by_name performs fuzzy search" do
    product1 = %Product{name: "Test"} |> Cognac.Repo.insert!
    product2 = %Product{name: "Test2"} |> Cognac.Repo.insert!
    product3 = %Product{name: "Hello"} |> Cognac.Repo.insert!
    assert Products.find_by_name("Test").id == product1.id
    assert Products.find_by_name("test2").id == product2.id
    assert Products.find_by_name("hell").id == product3.id
  end
end 