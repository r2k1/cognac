defmodule CognacWeb.PageController do
  use CognacWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
