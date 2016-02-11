defmodule Erande.SolutionControllerTest do
  use Erande.ConnCase

  alias Erande.Solution
  @valid_attrs %{body: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, solution_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing solutions"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, solution_path(conn, :new)
    assert html_response(conn, 200) =~ "New solution"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, solution_path(conn, :create), solution: @valid_attrs
    assert redirected_to(conn) == solution_path(conn, :index)
    assert Repo.get_by(Solution, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, solution_path(conn, :create), solution: @invalid_attrs
    assert html_response(conn, 200) =~ "New solution"
  end

  test "shows chosen resource", %{conn: conn} do
    solution = Repo.insert! %Solution{}
    conn = get conn, solution_path(conn, :show, solution)
    assert html_response(conn, 200) =~ "Show solution"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, solution_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    solution = Repo.insert! %Solution{}
    conn = get conn, solution_path(conn, :edit, solution)
    assert html_response(conn, 200) =~ "Edit solution"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    solution = Repo.insert! %Solution{}
    conn = put conn, solution_path(conn, :update, solution), solution: @valid_attrs
    assert redirected_to(conn) == solution_path(conn, :show, solution)
    assert Repo.get_by(Solution, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    solution = Repo.insert! %Solution{}
    conn = put conn, solution_path(conn, :update, solution), solution: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit solution"
  end

  test "deletes chosen resource", %{conn: conn} do
    solution = Repo.insert! %Solution{}
    conn = delete conn, solution_path(conn, :delete, solution)
    assert redirected_to(conn) == solution_path(conn, :index)
    refute Repo.get(Solution, solution.id)
  end
end
