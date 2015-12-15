defmodule Zohyothanksgiving.SolutionTest do
  use Zohyothanksgiving.ModelCase

  alias Zohyothanksgiving.Solution

  @valid_attrs %{body: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Solution.changeset(%Solution{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Solution.changeset(%Solution{}, @invalid_attrs)
    refute changeset.valid?
  end
end
