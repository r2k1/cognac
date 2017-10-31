defmodule Crawler.Store.Infotech do
  @behaviour Crawler.Store

  def currency() do
    "NZD"  
  end

  def store_id do
    3
  end

  def product_urls do
    Crawler.PageLoader.load!(http://www.einfo.co.nz/mobile-phones.html)
  end
end