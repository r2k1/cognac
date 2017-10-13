defmodule Crawler.ProductBuilder do
  def proccess do
    Enum.map(pages(), &create_product/1)
  end

  defp create_product(page) do
    html = page.body
    Cognac.Repo.insert!(%Cognac.Product{
      model_number: product_number(html),
      name: name(html)
    })
  end

  defp product_number(html) do
    Floki.find(html, "#out_container [itemprop=\"mpn\"]") 
    |> Floki.text
    |> String.trim
  end

  defp name(html) do
    html
    |> Floki.find("#out_container h1")
    |> Floki.text
    |> String.trim
  end

  def pages do
    Cognac.Page |> Cognac.Repo.all
  end
end