defmodule Zohyothanksgiving.PageController do
  use Zohyothanksgiving.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
