defmodule Erande.Answer do
  use Erande.Web, :model

  schema "answers" do
    field :respondent, :string
    belongs_to :solution, Erande.Solution

    timestamps
  end

  @required_fields ~w(respondent)
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
