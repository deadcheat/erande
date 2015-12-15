defmodule Zohyohtanksgiving.Repo.Migrations.CreateAnswer do
  use Ecto.Migration

  def change do
    create table(:answers) do
      add :respondent, :string
      add :solution_id, references(:solutions)

      timestamps
    end
    create index(:answers, [:solution_id])

  end
end
