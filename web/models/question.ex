defmodule Zohyothanksgiving.Question do
  use Zohyothanksgiving.Web, :model

  schema "questions" do
    field :title, :string
    field :body, :string

    has_one  :proposed_question, Zohyothanksgiving.ProposedQuestion
    has_many :solutions, Zohyothanksgiving.Solution
    has_many :collectanswers, Zohyothanksgiving.Collectanswer
    timestamps
  end

  @required_fields ~w(title body)
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
