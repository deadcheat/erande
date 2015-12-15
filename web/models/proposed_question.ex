defmodule Zohyohtanksgiving.ProposedQuestion do
  use Zohyohtanksgiving.Web, :model

  schema "proposed_questions" do
    belongs_to :question, Zohyohtanksgiving.Question

    timestamps
  end

  @required_fields ~w(question_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
