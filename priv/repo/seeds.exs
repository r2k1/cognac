# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Cognac.Repo.insert!(%Cognac.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
Cognac.Repo.insert!(%Cognac.Store{name: "PB Tech", host: "https://www.pbtech.co.nz/", homepage: "https://www.pbtech.co.nz/"})