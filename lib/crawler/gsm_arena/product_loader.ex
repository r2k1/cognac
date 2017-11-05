defmodule Crawler.GSMArena.ProductLoader do
  require Logger
  @moduledoc """
  Create products from https://www.gsmarena.com/ data
  """
  @host "https://www.gsmarena.com/"

  @spec load() :: list(%Cognac.Product{})
  def load do
    product_urls()
    |> Enum.map(&create_product/1)
  end

  def create_product(url) do
    Que.add(Crawler.GSMArena.ProductScrapper, url)
  end

  @spec product_urls() :: list(binary)
  def product_urls do
    "https://www.gsmarena.com/makers.php3"
    |> category_page_urls()
    |> Enum.flat_map(&product_list_page_urls/1)
    |> Enum.flat_map(&product_page_urls/1)
  end

  @spec category_page_urls(binary) :: list(binary)
  def category_page_urls(url) do
    Crawler.PageLoader.get!(url).body
    |> Floki.attribute("td a", "href")
    |> Enum.map(fn(href) -> @host <> href end)
  end
  
  @spec product_list_page_urls(binary) :: list(binary)
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

  @spec product_page_urls(binary) :: list(binary)
  def product_page_urls(product_list_url) do
    Crawler.PageLoader.get!(product_list_url).body
    |> Floki.attribute(".makers a", "href")
    |> Enum.map(fn(href) -> @host <> href end)
  end
end