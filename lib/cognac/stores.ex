defmodule Cognac.Stores do
  import Ecto.Query
  alias Cognac.Repo
  alias Cognac.Store

  @spec find_by_url(binary) :: %Store{}
  def find_by_url(url) do
    host = URI.parse(url).host
    query = from s in Store, where: s.host == ^host
    Repo.one(query)
  end
end