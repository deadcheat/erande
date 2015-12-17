defmodule Zohyothanksgiving.Repo.Migrations.AddStatusToProposedQuestion do
  use Ecto.Migration

  def change do
    alter table(:proposed_questions) do
      add :status, :string
    end
  end
end
