defmodule Erande.Solution do
  use Erande.Web, :model

  schema "solutions" do
    field :body, :string

    belongs_to :question, Erande.Question, foreign_key: :question_id
    has_one :collectanswer, Erande.Collectanswer
    has_many :answers, Erande.Answer
    timestamps
  end

  @required_fields ~w(body question_id)
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
