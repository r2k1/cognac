defmodule Crawler.GSMArena.ProductLoader do
  require Logger
  @moduledoc """
  Create products from https://www.gsmarena.com/ data
  """
  @host "https://www.gsmarena.com/"

  def load do
    category_page_urls("https://www.gsmarena.com/makers.php3")
    |> Enum.flat_map(&product_list_page_urls/1)
    |> Enum.flat_map(&product_page_urls/1)
    |> Enum.map(&create_product/1)
    |> Enum.reject(&is_nil/1)
  end

  def category_page_urls(url) do
    Crawler.PageLoader.get!(url).body
    |> Floki.attribute("td a", "href")
    |> Enum.map(fn(href) -> @host <> href end)
  end

  def product_list_page_urls(first_page_url) do
    case Crawler.PageLoader.get(first_page_url) do
      {:ok, page} ->
        page.body
        |> Floki.attribute(".nav-pages a", "href")
        |> Enum.map(fn(href) -> @host <> href end)
        |> Enum.concat([first_page_url])
      _ -> []
    end
    
  end

  def product_page_urls(product_list_url) do
    Crawler.PageLoader.get!(product_list_url).body
    |> Floki.attribute(".makers a", "href")
    |> Enum.map(fn(href) -> @host <> href end)
  end

  def create_product(url) do
    case Crawler.PageLoader.get(url) do
      {:error, _} -> nil
      {:ok, page} ->
        html = page.body
        name = Floki.find(html, "h1") |> Floki.text |> String.trim
        versions = Floki.find(html, "[data-version]:not([data-version='*'])")
                   |> Enum.map(&Floki.text/1)
                   |> Enum.map(&String.trim/1)
        Cognac.Products.insert_or_update_product(%{
          name: name,
          versions: versions,
          page_id: page.id
        }) 
    end
  end
end