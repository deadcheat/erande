defmodule Zohyothanksgiving.RankingController do
  use Zohyothanksgiving.Web, :controller

  alias Zohyothanksgiving.Answer
  alias Zohyothanksgiving.Collectanswer

  # get /ranking/
  def ranking(conn, _params) do
    query_rankers = from a in Answer,
                 inner_join: c in Collectanswer, on: c.solution_id == a.solution_id,
                 where: a.respondent != "",
                 group_by: [a.respondent, a.solution_id],
                 order_by: [desc: count(a.solution_id)],
                 select: {a.respondent, count(a.solution_id)}
    ranking = query_rankers |> Repo.all |> Enum.map fn {name, count} -> %{name: name, count: count} end
    query_norank = from a in Answer,
                 left_join: c in Collectanswer, on: c.solution_id != a.solution_id,
                 where: a.respondent != "",
                 group_by: [a.respondent, a.solution_id],
                 order_by: [desc: count(a.solution_id)],
                 select: {a.respondent, count(a.solution_id)}
    worstranking = query_norank |> Repo.all |> Enum.map fn {name, count} -> %{name: name, count: count} end
    IO.inspect ranking, pretty: true
    render(conn, "ranking.html", ranking: ranking, worstranking: worstranking)
  end
end