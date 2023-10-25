defmodule GothamManagerWeb.PageController do
  use GothamManagerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
