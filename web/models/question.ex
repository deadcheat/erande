defmodule Zohyohtanksgiving.Question do
  use Zohyohtanksgiving.Web, :model

  schema "questions" do
    field :title, :string
    field :body, :string

    has_many :questions, Zohyothanksgiving.Solution
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
