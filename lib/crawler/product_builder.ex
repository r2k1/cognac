defmodule Crawler.ProductBuilder do
  require Logger
  def proccess do
    Enum.map(pages(), &create_product/1)
  end

  defp create_product(page) do
    Logger.info "Page id: #{page.id}"
    html = page.body
    product = Cognac.Repo.insert!(%Cognac.Product{
      model_number: product_number(html),
      name: name(html)
    })
    Cognac.Repo.insert!(%Cognac.Product.Price{
      product_id: product.id,
      page_id: page.id,
      currency: "NZD",
      amount: amount(html)
    })
  end

  def product_number(html) do
    case Floki.find(html, "[itemprop=\"mpn\"]") |> Enum.fetch(0) do
      :error -> nil
      {:ok, element} ->
        element |> Floki.text |> String.trim
    end
  end

  defp name(html) do
    html
    |> Floki.find("h1")
    |> Enum.at(0)
    |> Floki.text
    |> String.trim
  end

  defp pages do
    Cognac.Page |> Cognac.Repo.all
  end

  defp amount(html) do
    text = html
    |> Floki.find(".ginc .dollars")
    |> Enum.at(0)
    |> Floki.text
    |> String.replace(~r/[^0-9.]/, "")
    |> Decimal.parse
    |> elem(1)
  end
end