## ---------------------------
## 解答選択肢に関連するRESTコントローラー
## ---------------------------
defmodule Zohyothanksgiving.SolutionController do
  use Zohyothanksgiving.Web, :controller

  alias Zohyothanksgiving.Solution
  alias Zohyothanksgiving.Question
  alias Zohyothanksgiving.Collectanswer

  plug :scrub_params, "solution" when action in [:create, :update]

  # get /questions/{question_id}/solutions/
  def index(conn, %{"question_id" => question_id}) do
    question = Repo.get(Question, question_id)
    solutions = Repo.all(from(s in Solution, where: s.question_id == ^question_id, order_by: s.id, preload: :collectanswer))
    render(conn, "index.html", question_id: question_id, solutions: solutions, question: question)
  end

  # get /questions/{question_id}/solutions/new
  def new(conn, %{"question_id" => question_id}) do
    changeset = Solution.changeset(%Solution{})
    render(conn, "new.html", question_id: question_id, changeset: changeset)
  end

  # post /questions/{question_id}/solutions/
  def create(conn, %{"solution" => solution_params}) do
    changeset = Solution.changeset(%Solution{}, solution_params)

    case Repo.insert(changeset) do
      {:ok, solution} ->
        conn
        |> put_flash(:info, "Solution created successfully.")
        |> redirect(to: question_solution_path(conn, :index, solution.question_id))
      {:error, changeset} ->
        render(conn, "new.html", question_id: solution_params["question_id"], changeset: changeset)
    end
  end

  # get /questions/{question_id}/solutions/{id}
  def show(conn, %{"id" => id}) do
    solution = Repo.get!(Solution, id)
    render(conn, "show.html", question_id: solution.question_id, solution: solution)
  end

  # get /questions/{question_id}/solutions/{id}/edit
  def edit(conn, %{"id" => id, "question_id" => question_id}) do
    solution = Repo.get!(Solution, id)
    changeset = Solution.changeset(solution)
    render(conn, "edit.html", question_id: question_id, solution: solution, changeset: changeset)
  end

  # put /questions/{question_id}/solutions/{id}
  def update(conn, %{"id" => id, "solution" => solution_params}) do
    solution = Repo.get!(Solution, id)
    changeset = Solution.changeset(solution, solution_params)

    case Repo.update(changeset) do
      {:ok, solution} ->
        conn
        |> put_flash(:info, "Solution updated successfully.")
        |> redirect(to: question_solution_path(conn, :show, solution.question_id, solution))
      {:error, changeset} ->
        render(conn, "edit.html", question_id: solution.question_id, solution: solution, changeset: changeset)
    end
  end

  # delete /questions/{question_id}/solutions/{id}
  def delete(conn, %{"id" => id, "question_id" => question_id}) do
    solution = Repo.get!(Solution, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(solution)

    conn
    |> put_flash(:info, "Solution deleted successfully.")
    |> redirect(to: question_solution_path(conn, :index, question_id))
  end

  ## ---------------------------
  ## 選択した選択肢を正答としてマーク
  ## ---------------------------
  def mark(conn, %{"id" => id, "question_id" => question_id}) do
    solution = Repo.get!(Solution, id)
    collectanswer = Ecto.Model.build(solution, :collectanswer, question_id: solution.question_id)
    Repo.insert!(collectanswer)
    conn
    |> put_flash(:info, "solution marked successfully.")
    |> redirect(to: question_solution_path(conn, :index, question_id))
  end

  ## ---------------------------
  ## 選択した選択肢の正答マークを削除
  ## ---------------------------
  def unmark(conn, %{"id" => id, "question_id" => question_id}) do
    solution = Repo.get!(Solution, id)
    Repo.delete_all(from(c in Collectanswer, where: c.solution_id == ^id))
    conn
    |> put_flash(:info, "solution unmarked successfully.")
    |> redirect(to: question_solution_path(conn, :index, question_id))
  end
end
