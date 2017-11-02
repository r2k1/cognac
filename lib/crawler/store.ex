defmodule Crawler.Store do
  @callback product_urls :: list
  @callback product_name(binary) :: binary
  @callback product_price(binary) :: Decimal.t
  @callback currency :: binary
  @callback store_id :: integer
end