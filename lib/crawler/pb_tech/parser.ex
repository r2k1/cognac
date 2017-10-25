defmodule Crawler.PBTech.Parser do
  import Ecto.Query
  @spec parse(binary) :: Cognac.Product.Price.t | nil
  def parse(url) do
    page = Crawler.PageLoader.get!(url)
    store_id = fetch_store_id()
    name = name(page.body)
    Cognac.Products.insert_or_update_price(%{
      name: name,
      store_id: store_id,
      page_id: page.id,
      amount: amount(page.body),
      currency: "NZD"
    })
  end

  @spec name(binary) :: binary
  def name(html) do
    html |> Floki.find("h1") |> Enum.at(0) |> Floki.text |> String.trim
  end

  @spec amount(binary) :: float
  def amount(html) do
    html |> Floki.find(".cost_wrap .ginc .dollars") |> Enum.at(0) |> Floki.text |> String.trim
    |> String.replace(~r/[^0-9.]/, "") |> Decimal.parse
  end

  @spec fetch_store_id :: integer
  defp fetch_store_id do
    query = from s in Cognac.Store, where: s.host == "https://www.pbtech.co.nz/"
    store = query |> Cognac.Repo.one
    store.id
  end
end