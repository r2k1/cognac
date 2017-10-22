defmodule Cognac.CategoryTest do
  use ExUnit.Case
  use Cognac.DataCase
  alias Cognac.Category

  @valid_attrs %{body: "some body", name: "some name"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Category.changeset(%Category{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Category.changeset(%Category{}, @invalid_attrs)
    refute changeset.valid?
  end
end
