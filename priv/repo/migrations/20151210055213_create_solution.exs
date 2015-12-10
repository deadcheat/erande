defmodule Zohyohtanksgiving.Repo.Migrations.CreateSolution do
  use Ecto.Migration

  def change do
    create table(:solutions) do
      add :body, :string

      timestamps
    end

  end
end
