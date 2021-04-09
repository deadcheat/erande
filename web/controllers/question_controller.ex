## ----------------------
## 問題管理コントローラー
## ----------------------
defmodule Erande.QuestionController do
  use Erande.Web, :controller

  alias Erande.Question
  alias Erande.Solution
  alias Erande.Answer
  alias Erande.ProposedQuestion

  plug :scrub_params, "question" when action in [:create, :update]

  # get /questions/
  def index(conn, _params) do
    questions = Repo.all(from(q in Question, preload: :proposed_question))
    render(conn, "index.html", questions: questions, current_user: get_session(conn, :current_user))
  end

  # get /questions/new
  def new(conn, _params) do
    changeset = Question.changeset(%Question{}, %{})
    render(conn, "new.html", changeset: changeset, current_user: get_session(conn, :current_user))
  end

  # post /questions/
  def create(conn, %{"question" => question_params}) do
    changeset = Question.changeset(%Question{}, question_params)

    case Repo.insert(changeset) do
      {:ok, _question} ->
        conn
        |> put_flash(:info, "Question created successfully.")
        |> redirect(to: question_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, current_user: get_session(conn, :current_user))
    end
  end

  # get /questions/:id
  def show(conn, %{"id" => id}) do
    question = Repo.get!(Question, id)
    solutions = Repo.all(from(s in Solution, where: s.question_id == ^question.id, order_by: s.id, preload: :collectanswer))
    query_answers = from a in Answer,
             left_join: s in Solution, on: s.id == a.solution_id and s.question_id == ^id,
             group_by: [a.solution_id],
             order_by: [asc: a.solution_id],
             select: {a.solution_id, count(a.solution_id)}
    answers = query_answers |> Repo.all |> Enum.map(fn {id, count} -> %{id => count} end)
    map_answers = merge_array_map(%{}, answers)
    IO.inspect question, pretty: true
    IO.inspect map_answers, pretty: true
    render(conn, "show.html", question: question, solutions: solutions, current_user: get_session(conn, :current_user), answers: map_answers)
  end

  def merge_array_map(src, [head|tail]) do
    merge_array_map(Map.merge(src, head), tail)
  end
  def merge_array_map(src, []) do
    src
  end

  # get /questions/:id/edit
  def edit(conn, %{"id" => id}) do
    question = Repo.get!(Question, id)
    changeset = Question.changeset(question, %{})
    render(conn, "edit.html", question: question, changeset: changeset, current_user: get_session(conn, :current_user))
  end

  # put /questions/:id
  def update(conn, %{"id" => id, "question" => question_params}) do
    question = Repo.get!(Question, id)
    changeset = Question.changeset(question, question_params)

    case Repo.update(changeset) do
      {:ok, question} ->
        conn
        |> put_flash(:info, "Question updated successfully.")
        |> redirect(to: question_path(conn, :show, question))
      {:error, changeset} ->
        render(conn, "edit.html", question: question, changeset: changeset, current_user: get_session(conn, :current_user))
    end
  end

  # delete /questions/:id
  def delete(conn, %{"id" => id}) do
    question = Repo.get!(Question, id)

    case Repo.one(from(s in Solution, select: count(s.id), where: s.question_id == ^id)) do
      x when x > 0 ->
        conn
        |> put_flash(:info, "選択肢を先に削除してください")
        |> redirect(to: question_path(conn, :index))

      _ ->
        Repo.delete_all(from(p in ProposedQuestion, where: p.question_id == ^id))
        # Here we use delete! (with a bang) because we expect
        # it to always work (and if it does not, it will raise).
        Repo.delete!(question)

        conn
        |> put_flash(:info, "Question deleted successfully.")
        |> redirect(to: question_path(conn, :index))
    end

  end

  # 問題公開
  def propose_question(conn, %{"id" => id}) do
    question = Repo.get!(Question, id)
               |> Repo.preload(solutions: from(s in Solution, order_by: s.id))
    Repo.delete_all(ProposedQuestion)
    proposed_question = Ecto.build_assoc(question, :proposed_question, status: "waiting")
    Repo.insert!(proposed_question)
    solutions = Repo.preload question.solutions, :collectanswer
    rs_solutions = Enum.map(solutions, fn(solution) -> %{id: solution.id, body: solution.body, correct: !is_nil(solution.collectanswer)} end)
    IO.inspect rs_solutions, pretty: true

    Erande.Endpoint.broadcast! "rooms:lobby", "proposed", %{question_id: question.id, question_title: question.title, question_body: question.body, solutions: rs_solutions}
    conn
    |> put_flash(:info, "問題を公開しました")
    |> redirect(to: question_path(conn, :show, id))
  end

  # 問題取り消し
  def unpropose(conn, _params) do
    Repo.delete_all(ProposedQuestion)
    Erande.Endpoint.broadcast! "rooms:lobby", "proposed", %{question_id: 0, question_title: "", question_body: "出題待ち", solutions: []}
    conn
    |> put_flash(:info, "問題を取り消ししました")
    |> redirect(to: question_path(conn, :index))
  end

  # アンサーチェック！
  def answercheck(conn, %{"id" => id}) do
    proposed_questions = Repo.all ProposedQuestion
    if length(proposed_questions) == 1 do
      [proposed_question] = proposed_questions
      changeset = Ecto.Changeset.change proposed_question, status: "dead"
      Repo.update!(changeset)
      query  = from s in Solution,
                   left_join: a in Answer, on: a.solution_id == s.id,
                   where: s.question_id == ^proposed_question.question_id,
                   group_by: s.id,
                   order_by: s.id,
                   select: {s.id, count(a.id)}
      answers = Repo.all(query) |> Enum.map(fn {id, count} -> %{id: id, count: count} end)
      Erande.Endpoint.broadcast! "rooms:lobby", "answercheck", %{answers: answers}
      IO.inspect answers, pretty: true
    end
    conn
    |> put_flash(:info, "問題画面に解答状況を反映しました")
    |> redirect(to: question_path(conn, :show, id))
  end

  # アンサーオープン
  def answeropen(conn, %{"id" => id}) do
    Erande.Endpoint.broadcast! "rooms:lobby", "answeropen", %{}
    conn
    |> put_flash(:info, "問題画面に解答を反映しました")
    |> redirect(to: question_path(conn, :show, id))
  end

  # 回答データをリセット
  def answerclean(conn, _param) do
    Repo.delete_all(Answer)
    conn
    |> put_flash(:info, "回答データを消去しました")
    |> redirect(to: question_path(conn, :index))
  end
end
