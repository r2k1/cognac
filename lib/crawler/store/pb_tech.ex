defmodule Crawler.Store.PBTech do
  require Logger
  @behaviour Crawler.Store
  @hostname "https://www.pbtech.co.nz/"

  def currency do
    "NZD"
  end

  def product_urls do
    category_urls()
    |> Enum.flat_map(&extract_page_urls_from_category/1)
    |> Enum.flat_map(&extract_urls_from_page/1)
    |> Enum.reject(fn(x) -> x == nil end)
    |> Enum.uniq
  end

  def product_name(html) do
    html |> Floki.find("h1") |> Enum.at(0) |> Floki.text |> String.trim
  end

  def store_id do
    1
  end

  def product_price(html) do
    {:ok, value} = html
    |> Floki.find(".cost_wrap .ginc .dollars")
    |> Enum.at(0)
    |> Floki.text
    |> String.trim
    |> String.replace(~r/[^0-9.]/, "")
    |> Decimal.parse
    value  
  end

  @spec category_urls :: [binary]
  defp category_urls do
    [
      "https://www.pbtech.co.nz/category/phones-gps/smartphones/android-phones",
      "https://www.pbtech.co.nz/category/phones-gps/smartphones/apple-ios-phones",
      "https://www.pbtech.co.nz/category/phones-gps/smartphones/windows-phones"
    ]
  end

  @spec extract_page_urls_from_category(binary) :: [binary]
  defp extract_page_urls_from_category(category_url) do
    Logger.info "Loading category #{category_url}"
    urls = Crawler.PageLoader.get!(category_url).body
    |> Floki.find(".pagination a")
    |> Floki.attribute("href")
    |> Enum.map(&url/1)
    [category_url | urls]
    |> Enum.reject(fn(x) -> x == nil end)
    |> Enum.uniq
  end

  @spec extract_urls_from_page(binary) :: [binary]
  defp extract_urls_from_page(page_url) do
    Crawler.PageLoader.get!(page_url).body
    |> Floki.find(".item_line_name")
    |> Floki.attribute("href")
    |> Enum.reject(fn(x) -> x == nil end)
    |> Enum.uniq
    |> Enum.map(&url/1)
  end

  defp url(href) do
    @hostname <> href
  end  
end