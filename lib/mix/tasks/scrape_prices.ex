defmodule Mix.Tasks.ScrapePrices do
  use Mix.Task

  def run(_args) do
    Mix.Task.run "app.start", []
    Crawler.crawl(Crawler.Store.ExpertInfotech)
    Crawler.crawl(Crawler.Store.PBTech)
    Crawler.crawl(Crawler.Store.MobileStation)
  end
end