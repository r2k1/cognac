defmodule Crawler do
  require Logger

  def crawl(store) do
    urls = store.product_urls
    |> Enum.reject(fn(x) -> x == nil end)
    |> Enum.uniq
    prices = urls 
    |> Enum.map(fn(url) -> parse(store, url) end)
    |> Enum.reject(fn(x) -> x == nil end)
    |> Enum.uniq
    Logger.info("Proccessed #{Enum.count(urls)} product pages from #{store}")
    Logger.info("Updated #{Enum.count(prices)} items from #{store}")
    prices
  end

  def parse(store, url) do
    page = Crawler.PageLoader.get!(url)
    Cognac.Products.insert_or_update_price(%{
      name: store.product_name(page.body),
      store_id: store.store_id,
      url: page.url,
      amount: store.product_price(page.body),
      currency: store.currency
    })
  end
end