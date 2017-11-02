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
Cognac.Repo.insert!(%Cognac.Store{name: "PB Tech", host: "www.pbtech.co.nz", homepage: "https://www.pbtech.co.nz/"})
Cognac.Repo.insert!(%Cognac.Store{name: "Mobile Station", host: "www.mobilestation.co.nz", homepage: "http://www.mobilestation.co.nz/"})
Cognac.Repo.insert!(%Cognac.Store{name: "Expert Infotech", host: "www.einfo.co.nz", homepage: "http://www.einfo.co.nz/"})
Crawler.GSMArena.ProductLoader.load
Crawler.crawl(Crawler.Store.ExpertInfotech)
Crawler.crawl(Crawler.Store.PBTech)
Crawler.crawl(Crawler.Store.MobileStation)