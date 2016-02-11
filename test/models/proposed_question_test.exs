defmodule Erande.ProposedQuestionTest do
  use Erande.ModelCase

  alias Erande.ProposedQuestion

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ProposedQuestion.changeset(%ProposedQuestion{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ProposedQuestion.changeset(%ProposedQuestion{}, @invalid_attrs)
    refute changeset.valid?
  end
end
