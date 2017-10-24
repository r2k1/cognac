defmodule Crawler.PBSeed do
  require Logger
  @hostname "https://www.pbtech.co.nz/"
  def seed do
    categories()
    |> Enum.map(&load_category/1)
    |> Crawler.PageLoader.get!
  end

  defp categories do
    ["https://www.pbtech.co.nz/category/phones-gps/smartphones/android-phones"]
  end

  defp load_category(url) do
    Logger.info "Loading category #{url}"
    HTTPoison.get!(url).body
    |> Floki.find(".pagination a")
    |> Floki.attribute("href")
    |> Enum.map(&url/1)
    |> Enum.map(&load_list/1)
  end

  defp load_list(url) do
    Logger.info "Loading list #{url}"
    HTTPoison.get!(url).body
    |> Floki.find(".item_line_name")
    |> Floki.attribute("href")
    |> Enum.map(&url/1)
  end

  defp insert_page(url) do
    Logger.info("Loading page #{url}")
    {status, %{body: body, status_code: status_code}} = HTTPoison.get(url)
    Cognac.Repo.insert!(%Cognac.Page{
      body: body,
      status_code: status_code,
      url: url,
      visited_at: Ecto.DateTime.utc
    })
  end

  defp url(href) do
    @hostname <> href
  end
end