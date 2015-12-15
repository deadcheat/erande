defmodule Zohyothanksgiving.Repo.Migrations.CreateQuestion do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :title, :string
      add :body, :string

      timestamps
    end

  end
end
