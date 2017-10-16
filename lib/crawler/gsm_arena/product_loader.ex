defmodule Crawler.GSMArena.ProductLoader do
  @moduledoc """
  Create products from https://www.gsmarena.com/ data
  """
  @host "https://www.gsmarena.com/"

  def load do
    category_page_urls("https://www.gsmarena.com/makers.php3")
  end

  def category_page_urls(url) do
    HTTPoison.get!(url).body
    |> Floki.attribute("td a", "href")
    |> Enum.map(fn(href) -> @host <> href end)
  end

  def product_list_page_urls(first_page_url) do
    HTTPoison.get!(first_page_url).body
    |> Floki.attribute(".nav-pages a", "href")
    |> Enum.map(fn(href) -> @host <> href end)
    |> Enum.concat([first_page_url])
  end

  def product_page_urls(product_list_url) do
    HTTPoison.get!(product_list_url).body
    |> Floki.attribute(".makers a", "href")
    |> Enum.map(fn(href) -> @host <> href end)
  end

  def load_product(url) do
    html = HTTPoison.get!(url).body
    name = Floki.find(html, "h1") |> Floki.text
    product_number = Floki.find(html, "[data-spec='comment']") |> Floki.text
  end
end