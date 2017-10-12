defmodule Cognac.Page do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cognac.Page


  schema "pages" do
    field :body, :string
    field :status_code, :integer
    field :url, :string
    field :visited_at, :naive_datetime
    field :store_id, :id

    timestamps()
  end

  @doc false
  def changeset(%Page{} = page, attrs) do
    page
    |> cast(attrs, [:url, :status_code, :visited_at, :body])
    |> validate_required([:url, :status_code, :visited_at])
  end
end
