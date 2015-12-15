defmodule Zohyohtanksgiving.ProposedQuestionTest do
  use Zohyohtanksgiving.ModelCase

  alias Zohyohtanksgiving.ProposedQuestion

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
