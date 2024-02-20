defmodule RallyScore.ScoresTest do
  use RallyScore.DataCase

  alias RallyScore.Scores

  describe "challenges" do
    alias RallyScore.Scores.Challenge

    import RallyScore.ScoresFixtures

    @invalid_attrs %{name: nil, order: nil}

    test "list_challenges/0 returns all challenges" do
      challenge = challenge_fixture()
      assert Scores.list_challenges() == [challenge]
    end

    test "get_challenge!/1 returns the challenge with given id" do
      challenge = challenge_fixture()
      assert Scores.get_challenge!(challenge.id) == challenge
    end

    test "create_challenge/1 with valid data creates a challenge" do
      valid_attrs = %{name: "some name", order: 42}

      assert {:ok, %Challenge{} = challenge} = Scores.create_challenge(valid_attrs)
      assert challenge.name == "some name"
      assert challenge.order == 42
    end

    test "create_challenge/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Scores.create_challenge(@invalid_attrs)
    end

    test "update_challenge/2 with valid data updates the challenge" do
      challenge = challenge_fixture()
      update_attrs = %{name: "some updated name", order: 43}

      assert {:ok, %Challenge{} = challenge} = Scores.update_challenge(challenge, update_attrs)
      assert challenge.name == "some updated name"
      assert challenge.order == 43
    end

    test "update_challenge/2 with invalid data returns error changeset" do
      challenge = challenge_fixture()
      assert {:error, %Ecto.Changeset{}} = Scores.update_challenge(challenge, @invalid_attrs)
      assert challenge == Scores.get_challenge!(challenge.id)
    end

    test "delete_challenge/1 deletes the challenge" do
      challenge = challenge_fixture()
      assert {:ok, %Challenge{}} = Scores.delete_challenge(challenge)
      assert_raise Ecto.NoResultsError, fn -> Scores.get_challenge!(challenge.id) end
    end

    test "change_challenge/1 returns a challenge changeset" do
      challenge = challenge_fixture()
      assert %Ecto.Changeset{} = Scores.change_challenge(challenge)
    end
  end
end
