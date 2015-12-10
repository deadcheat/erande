defmodule Zohyohtanksgiving.SolutionController do
  use Zohyohtanksgiving.Web, :controller

  alias Zohyohtanksgiving.Solution

  plug :scrub_params, "solution" when action in [:create, :update]

  def index(conn, _params) do
    solutions = Repo.all(Solution)
    render(conn, "index.html", solutions: solutions)
  end

  def new(conn, _params) do
    changeset = Solution.changeset(%Solution{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"solution" => solution_params}) do
    changeset = Solution.changeset(%Solution{}, solution_params)

    case Repo.insert(changeset) do
      {:ok, _solution} ->
        conn
        |> put_flash(:info, "Solution created successfully.")
        |> redirect(to: question_solution_path(conn, :index, @question))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    solution = Repo.get!(Solution, id)
    render(conn, "show.html", solution: solution)
  end

  def edit(conn, %{"id" => id}) do
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

  def delete(conn, %{"id" => id}) do
    solution = Repo.get!(Solution, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(solution)

    conn
    |> put_flash(:info, "Solution deleted successfully.")
    |> redirect(to: question_solution_path(conn, :index, @question))
  end
end
