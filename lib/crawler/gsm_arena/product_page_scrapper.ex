defmodule Crawler.GSMArena.ProductScrapper do
  use Que.Worker, concurrency: 20

  def perform(url) do
    create_product(url)
  end

  @spec create_product(binary) :: %Cognac.Product{} | nil
  defp create_product(url) do
    require Logger
    Logger.debug "Scrapping product for #{url}"
    case Crawler.PageLoader.get(url) do
      {:error, _} -> nil
      {:ok, page} ->
        html = page.body
        name = html |> Floki.find("h1") |> Floki.text |> String.trim
        versions = html
                   |> Floki.find("[data-version]:not([data-version='*'])")
                   |> Enum.map(&Floki.text/1)
                   |> Enum.map(&String.trim/1)
        Cognac.Products.insert_or_update_product(%{
          name: name,
          versions: versions,
          page_id: page.id
        }) 
    end
  end
end