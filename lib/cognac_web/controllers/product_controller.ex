defmodule CognacWeb.ProductController do
  use CognacWeb, :controller

  def index(conn, _params) do
    products = Cognac.Products.list_products()
    render conn, "index.html", products: products
  end

  def show(conn, %{"id" => id}) do
    product = Cognac.Products.get_product!(id)
    render conn, "show.html", product: product
  end
end
