defmodule Zohyothanksgiving.Repo.Migrations.CreateProposedQuestion do
  use Ecto.Migration

  def change do
    create table(:proposed_questions) do
      add :question_id, references(:questions)

      timestamps
    end
    create index(:proposed_questions, [:question_id])

  end
end
