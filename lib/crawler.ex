defmodule Crawler do
  require Logger

  def crawl(store_module) do
    urls = store_module.product_urls
    |> Enum.reject(fn(x) -> x == nil end)
    |> Enum.uniq
    store = urls |> Enum.at(0) |> Cognac.Stores.find_by_url
    urls 
    |> Enum.map(fn(url) -> parse(store_module, store, url) end)
  end

  defp parse(store_module, store, url) do
    Que.add(Crawler.PriceScrapper, {store_module, store, url})
  end
end