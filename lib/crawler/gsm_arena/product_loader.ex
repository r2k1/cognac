defmodule Crawler.GSMArena.ProductLoader do
  require Logger
  @moduledoc """
  Create products from https://www.gsmarena.com/ data
  """
  @host "https://www.gsmarena.com/"

  def load do
    product_urls()
    |> Enum.map(&create_product/1)
  end

  def create_product(url) do
    Logger.info "creating product for #{url}"
    case Crawler.PageLoader.get(url) do
      {:error, _} -> nil
      {:ok, page} ->
        html = page.body
        name = html |> Floki.find("h1") |> Floki.text |> String.trim
        versions = html
                   |> Floki.find("[data-version]:not([data-version='*'])")
                   |> Enum.map(&Floki.text/1)
                   |> Enum.map(&String.trim/1)
        Cognac.Products.insert_or_update_product(%{
          name: name,
          versions: versions,
          page_id: page.id
        }) 
    end
  end

  def product_urls do
    "https://www.gsmarena.com/makers.php3"
    |> category_page_urls()
    |> Enum.flat_map(&product_list_page_urls/1)
    |> Enum.flat_map(&product_page_urls/1)
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
end