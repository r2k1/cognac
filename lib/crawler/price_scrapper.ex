defmodule Crawler.PriceScrapper do
  use Que.Worker, concurrency: 20
  def perform({store_module, store, url}) do
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