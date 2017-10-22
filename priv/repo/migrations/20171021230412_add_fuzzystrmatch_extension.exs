defmodule Cognac.Repo.Migrations.AddFuzzystrmatchExtension do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION fuzzystrmatch"
  end
end
