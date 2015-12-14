defmodule Zohyohtanksgiving.Repo.Migrations.CreateCollectanswer do
  use Ecto.Migration

  def change do
    create table(:collectanswers) do
      add :question_id, references(:questions)
      add :solution_id, references(:solutions)

      timestamps
    end
    create index(:collectanswers, [:question_id])
    create index(:collectanswers, [:solution_id])

  end
end
