defmodule Crawler.PageLoader do
  require Logger
  import Ecto.Query
  @moduledoc """
  Load page, use cache if previously visited
  """
  @type response :: {:ok, Cognac.Page.t} | {:error, term}

  @doc """
  Returns cached result if exists, otherwise
  issues HTTP request for a given url.

  On success caches the result for the future requests
  """
  @spec get(binary) :: response
  def get(url) do
    case find_page(url) do
      nil -> 
        Logger.info("Loading #{url}")
        load(url)
      page ->
        Logger.info("Hit cache for #{url}")
        {:ok, page}
    end
  end

  @doc """
  Works exactly as `get/1` but returns only result
  Raises an exception in case of HTTP error
  """
  @spec get!(binary) :: Cognac.Page.t
  def get!(url) do
    case get(url) do
      {:error, error} -> raise Atom.to_string(error)
      {:ok, result} -> result
    end
  end

  @doc """
  Issues HTTP request for given url
  On success caches result for future requests
  """
  @spec load(binary) :: response
  def load(url) do
    case HTTPoison.get(url, %{}, hackney: [follow_redirect: true, pool: :default]) do
      {:ok, response} -> proccess_response(response)
      {:error, error} -> {:error, error.reason}
    end
  end

  @doc """
  Issues an HTTP request to the given url, raising an exception in case of failure.

  `load!/1` works exactly like `load/1` but it returns just the
  response in case of a successful request, raising an exception in case the
  request fails.
  """
  @spec load!(binary) :: Cognac.Page.t
  def load!(url) do
    case load(url) do
      {:error, error} -> raise error
      {:ok, result} -> result  
    end
  end

  defp proccess_response(response) do
    case response.status_code do
      x when x < 200 or x >= 300 -> {:error, :unsuccessful_response}
      _ ->
        {:ok, update_or_create_page(response)}
    end
  end

  defp update_or_create_page(response) do
    query = from p in Cognac.Page, where: p.url == ^response.request_url
    Cognac.Repo.one(query) || %Cognac.Page{}
    |> Cognac.Page.changeset(%{
      status_code: response.status_code,
      url: response.request_url,
      body: strip_utf(response.body),
      headers: to_map(response.headers),
      visited_at: NaiveDateTime.utc_now
    })
    |> Cognac.Repo.insert_or_update!
  end

  @spec to_map(list) :: map
  defp to_map(headers) do
    headers
    |> Enum.reduce(%{}, fn(x, acc) -> Map.put(acc, elem(x, 0), elem(x, 1)) end)
  end

  defp find_page(url) do
    query = from p in Cognac.Page,
            where: p.url == ^url
    Cognac.Repo.one(query)
  end

  def strip_utf(str) do
    strip_utf_helper(str, [])
  end

  defp strip_utf_helper(<<x :: utf8>> <> rest, acc) do
    strip_utf_helper rest, [x | acc]
  end

  defp strip_utf_helper(<<x>> <> rest, acc), do: strip_utf_helper(rest, acc)

  defp strip_utf_helper("", acc) do
    acc
    |> :lists.reverse
    |> List.to_string
  end
end