defmodule Zohyohtanksgiving.PageController do
  use Zohyohtanksgiving.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
