defmodule Zohyohtanksgiving.CollectanswerTest do
  use Zohyohtanksgiving.ModelCase

  alias Zohyohtanksgiving.Collectanswer

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Collectanswer.changeset(%Collectanswer{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Collectanswer.changeset(%Collectanswer{}, @invalid_attrs)
    refute changeset.valid?
  end
end
