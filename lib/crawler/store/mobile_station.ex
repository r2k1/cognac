defmodule Crawler.Store.MobileStation do
  @behaviour Crawler.Store

  def currency do
    "NZD"
  end

  def store_id do
    2
  end

  def product_name(html) do
    html |> Floki.find("h1") |> Enum.at(0) |> Floki.text 
  end

  def product_price(html) do
    {:ok, value} = html
    |> Floki.find("span.price")
    |> Enum.at(0)
    |> Floki.text
    |> String.trim
    |> String.replace(~r/[^0-9.]/, "")
    |> Decimal.parse
    value  
  end
  
  def product_urls do
    Crawler.PageLoader.load!("http://www.mobilestation.co.nz/index.php/catalog/seo_sitemap/product/").body
    |> Floki.find("a.last")
    |> Enum.at(0)
    |> Floki.text
    |> Integer.parse
    |> elem(0)
    product_page_urls = for p <- 1..pages_count, do: "http://www.mobilestation.co.nz/index.php/catalog/seo_sitemap/product/?p=#{p}"
    product_page_urls
    |> Enum.flat_map(&load_product_urls_from_page/1)
  end

  def load_product_urls_from_page(url) do
    Crawler.PageLoader.load!(url).body
    |> Floki.find(".sitemap li a")
    |> Floki.attribute("href")
  end
end
