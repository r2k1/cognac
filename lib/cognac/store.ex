defmodule Cognac.Store do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cognac.Store


  schema "stores" do
    field :host, :string
    field :name, :string
    field :home_page, :string

    timestamps()
  end

  @doc false
  def changeset(%Store{} = store, attrs) do
    store
    |> cast(attrs, [:name, :host, :home_page])
    |> validate_required([:name, :host, :home_page])
  end
end
