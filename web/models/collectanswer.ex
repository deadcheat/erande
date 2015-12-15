defmodule Zohyothanksgiving.Collectanswer do
  use Zohyothanksgiving.Web, :model

  schema "collectanswers" do
    belongs_to :question, Zohyothanksgiving.Question, foreign_key: :question_id
    belongs_to :solution, Zohyothanksgiving.Solution, foreign_key: :solution_id

    timestamps
  end

  @required_fields ~w(question_id solution_id)
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
