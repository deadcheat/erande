defmodule Zohyothanksgiving.PageController do
  use Zohyothanksgiving.Web, :controller
  plug Ueberauth
  alias Ueberauth.Strategy.Helpers

  def index(conn, _params) do
    render conn, "index.html", current_user: get_session(conn, :current_user)
  end
end
