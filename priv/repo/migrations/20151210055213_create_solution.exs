defmodule Erande.Repo.Migrations.CreateSolution do
  use Ecto.Migration

  def change do
    create table(:solutions) do
      add :body, :string
      add :question_id, references(:questions)

      timestamps
    end

  end
end
