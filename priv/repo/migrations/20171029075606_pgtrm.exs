defmodule Cognac.Repo.Migrations.Pgtrm do
  use Ecto.Migration

  def change do
    execute "DROP EXTENSION fuzzystrmatch"
    execute "CREATE EXTENSION pg_trgm"
    execute "CREATE INDEX products_name_trgm_index ON products USING gin (name gin_trgm_ops)"    
  end
end
