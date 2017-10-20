defmodule Crawler.PbTech do
  require Logger
  use GenServer
  @moduledoc """
  Web spider
  """

  @base_url "https://www.pbtech.co.nz/"

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Logger.info('Start pt tech crawler')
    schedule_work() # Schedule work to be performed on start
    {:ok, state}
  end

  def handle_info(:work, state) do
    # Do the desired work here
    Logger.info('Loop')
    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 1 * 1000) # In 2 hours
  end

  defp initial_queue() do
  end

  defp category_pages() do
    ['https://www.pbtech.co.nz/category/phones-gps/smartphones/android-phones']
  end

  # defp list_pages() do
  #   case HTTPoison.get(url) do
  #     {:ok, %HTTPoison.Response(status_code: 200, body: body)} ->
  #       body
  #       |> Floki.find(".pages a")
  #       |> Floki.attribute("href")
  #     {:error, %HTTPoison.Error{reason: reason}} ->
  #       Logger.error("#{:reason} Error during download #{:url}")
  #   end
  # end

  def android_skus do
    ['https://www.pbtech.co.nz/category/phones-gps/smartphones/android-phones']
    |> Enum.map(&(HTTPoison.get!(&1).body))
    |> Enum.map(&(Floki.find(&1, ".pagination a")))
    |> Enum.map(&(Floki.attribute(&1, "href")))
    |> List.flatten
    |> Enum.map(&(@base_url <> &1))
    |> Enum.map(&(HTTPoison.get!(&1).body))
    |> Enum.map(&(Floki.find(&1, ".item_line_name")))
    |> Enum.map(&(Floki.attribute(&1, "href")))
    |> List.flatten
  end

  def get_sku(href) do
    @base_url <> href
    |> HTTPoison.get!
    |> Map.get(:body)
    |> Floki.find("[itemprop=\"mpn\"]")
    |> Enum.fetch(0)
    |> Floki.text
    |> String.trim
  end
end