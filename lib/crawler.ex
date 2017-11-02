defmodule Crawler do
  require Logger

  @spec crawl(module) :: list(%Cognac.Product.Price{})
  def crawl(store_module) do
    urls = store_module.product_urls
    store = urls |> Enum.at(0) |> Cognac.Stores.find_by_url
    |> Enum.reject(fn(x) -> x == nil end)
    |> Enum.uniq
    prices = urls 
    |> Enum.map(fn(url) -> parse(store_module, store, url) end)
    |> Enum.reject(fn(x) -> x == nil end)
    |> Enum.uniq
    Logger.info("Proccessed #{Enum.count(urls)} product pages from #{store_module}")
    Logger.info("Updated #{Enum.count(prices)} items from #{store_module}")
    prices
  end

  @spec parse(module, %Cognac.Store{}, binary) :: %Cognac.Product{} | nil
  def parse(store_module, store, url) do
    case Crawler.PageLoader.get(url) do
      {:ok, page} -> create_price(store_module, store, page)
      {:error, _} -> nil
    end
  end

  @spec create_price(module, %Cognac.Store{}, %Cognac.Page{}) :: %Cognac.Product{} | nil
  defp create_price(store_module, store, page) do
    Cognac.Products.insert_or_update_price(%{
      name: store_module.product_name(page.body),
      store_id: store.id,
      url: page.url,
      amount: store_module.product_price(page.body),
      currency: store_module.currency
    })
  end    
end