defmodule Zohyothanksgiving.RankingController do
  use Zohyothanksgiving.Web, :controller

  alias Zohyothanksgiving.Answer
  alias Zohyothanksgiving.Collectanswer

  # get /ranking/
  def ranking(conn, _params) do
    query = from a in Answer,
                 inner_join: c in Collectanswer, on: c.solution_id == a.solution_id,
                 group_by: a.respondent,
                 order_by: [desc: count(a.id)],
                 select: {a.respondent, count(a.id)}
    ranking = query |> Repo.all |> Enum.map fn {name, count} -> %{name: name, count: count} end
    IO.inspect ranking, pretty: true
    render(conn, "ranking.html", ranking: ranking)
  end
end