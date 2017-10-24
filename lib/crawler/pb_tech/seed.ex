defmodule Crawler.PBTech.Seed do
  require Logger
  @hostname "https://www.pbtech.co.nz/"

  def download do
    category_urls()
    |> Enum.flat_map(&page_urls/1)
    |> Enum.flat_map(&product_urls/1)
    |> Enum.reject(fn(x) -> x == nil end)
    |> Enum.uniq
    |> Enum.map(&Crawler.PBTech.Parser.parse/1)
    |> Enum.reject(fn(x) -> x == nil end)
  end

  @spec category_urls :: [binary]
  def category_urls do
    [
      "https://www.pbtech.co.nz/category/phones-gps/smartphones/android-phones",
      "https://www.pbtech.co.nz/category/phones-gps/smartphones/apple-ios-phones",
      "https://www.pbtech.co.nz/category/phones-gps/smartphones/windows-phones"
    ]
  end

  @spec page_urls(binary) :: [binary]
  def page_urls(category_url) do
    Logger.info "Loading category #{category_url}"
    urls = Crawler.PageLoader.get!(category_url).body
    |> Floki.find(".pagination a")
    |> Floki.attribute("href")
    |> Enum.map(&url/1)
    [category_url | urls]
    |> Enum.reject(fn(x) -> x == nil end)
    |> Enum.uniq
  end

  @spec product_urls(binary) :: [binary]
  def product_urls(page_url) do
    Crawler.PageLoader.get!(page_url).body
    |> Floki.find(".item_line_name")
    |> Floki.attribute("href")
    |> Enum.reject(fn(x) -> x == nil end)
    |> Enum.uniq
    |> Enum.map(&url/1)
  end

  def url(href) do
    @hostname <> href
  end
end
