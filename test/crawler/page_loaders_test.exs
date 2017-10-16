defmodule Crawler.PageLoaderTest do
  use ExUnit.Case
  use Cognac.DataCase

  setup_all do
    {:ok, _} = :application.ensure_all_started(:httparrot)
    :ok
  end

  test "get non-cached page" do
    {:ok, page} = Crawler.PageLoader.get("localhost:8080/html")
    assert page.url == "http://localhost:8080/html"
    assert page.status_code == 200
    assert !is_nil(page.visited_at)
    assert is_map(page.headers)
  end

  test "get returns previously cached page" do
    page = Crawler.PageLoader.get!("localhost:8080/html")
    assert is_integer(page.id)
    page2 = Crawler.PageLoader.get!("localhost:8080/html")
    assert page.id == page2.id
  end

  test "get Unauthorized url" do
    {:error, _} = Crawler.PageLoader.get("localhost:8080/status/401")
  end
end