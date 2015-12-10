defmodule Zohyohtanksgiving.SolutionController do
  use Zohyohtanksgiving.Web, :controller

  alias Zohyohtanksgiving.Solution

  plug :scrub_params, "solution" when action in [:create, :update]

  def index(conn, %{"question_id" => question_id}) do
    solutions = Repo.all(Solution)
    render(conn, "index.html", solutions: solutions, question_id: question_id)
  end

  def new(conn, %{"question_id" => question_id}) do
    changeset = Solution.changeset(%Solution{})
    render(conn, "new.html", changeset: changeset, question_id: question_id)
  end

  def create(conn, %{"solution" => solution_params, "question_id" => question_id}) do
    changeset = Solution.changeset(%Solution{}, solution_params)

    case Repo.insert(changeset) do
      {:ok, _solution} ->
        conn
        |> put_flash(:info, "Solution created successfully.")
        |> redirect(to: question_solution_path(conn, :index, question_id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset, question_id: question_id)
    end
  end

  def show(conn, %{"id" => id}) do
    solution = Repo.get!(Solution, id)
    render(conn, "show.html", solution: solution, question_id: solution.question_id)
  end

  def edit(conn, %{"id" => id, "question_id" => question_id}) do
    solution = Repo.get!(Solution, id)
    changeset = Solution.changeset(solution)
    render(conn, "edit.html", solution: solution, changeset: changeset)
  end

  def update(conn, %{"id" => id, "solution" => solution_params}) do
    solution = Repo.get!(Solution, id)
    changeset = Solution.changeset(solution, solution_params)

    case Repo.update(changeset) do
      {:ok, solution} ->
        conn
        |> put_flash(:info, "Solution updated successfully.")
        |> redirect(to: question_solution_path(conn, :show, solution))
      {:error, changeset} ->
        render(conn, "edit.html", solution: solution, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id, "question_id" => question_id}) do
    solution = Repo.get!(Solution, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(solution)

    conn
    |> put_flash(:info, "Solution deleted successfully.")
    |> redirect(to: question_solution_path(conn, :index, question_id: question_id))
  end
end
