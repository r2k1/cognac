defmodule Cognac.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias Cognac.Category

  schema "categories" do
    field :name, :string
    field :body, :string
    has_many :products, Cognac.Product

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :body])
    |> validate_required([:name])
  end
end
