defmodule Zohyohtanksgiving.ProposeTest do
  use Zohyohtanksgiving.ModelCase

  alias Zohyohtanksgiving.Propose

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Propose.changeset(%Propose{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Propose.changeset(%Propose{}, @invalid_attrs)
    refute changeset.valid?
  end
end
