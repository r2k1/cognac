defmodule Crawler.Store.ExpertInfotech do
  @behaviour Crawler.Store

  def currency() do
    "NZD"  
  end

  def store_id do
    3
  end

  def product_name(html) do
    html |> Floki.find("[itemprop=\"name\"]") |> Floki.text
  end

  def product_price(html) do
    {:ok, value} = html
    |> Floki.find("[itemprop=\"price\"]")
    |> Enum.at(0)
    |> Floki.text
    |> String.trim
    |> String.replace(~r/[^0-9.]/, "")
    |> Decimal.parse
    value
  end

  def product_urls do
    category_urls()
    |> Enum.flat_map(&page_urls/1)
    |> Enum.flat_map(&product_urls/1)
  end

  def product_urls(page_url) do
    Crawler.PageLoader.load!(page_url).body
    |> Floki.find(".product-name a")
    |> Floki.attribute("href")
    |> Enum.uniq
  end

  def category_urls do
    Crawler.PageLoader.load!("http://www.einfo.co.nz/mobile-phones.html").body
    |> Floki.find(".categoryListing-data a")
    |> Floki.attribute("href")
    |> Enum.uniq
    |> Enum.slice(0..-2)
  end

  def page_urls(category_url) do
    pages = Crawler.PageLoader.load!(category_url).body
    |> Floki.find(".pages li a")
    |> Floki.attribute("href")
    [category_url | pages]
    |> Enum.uniq
  end
end